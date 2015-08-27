require 'spec_helper'

describe AmpelExtase::JenkinsStateObserver do
  before do
    allow_any_instance_of(AmpelExtase::JenkinsClient).to receive(:puts)
    allow_any_instance_of(described_class).to receive(:puts)
  end

  let :client do
    double('AmpelExtase::JenkinsClient', url: 'http://foo/bar')
  end

  before do
    allow(client).to receive(:fetch).and_return true
  end

  let :jso do
    described_class.new client
  end

  describe '.for_url' do
    it 'creates a state observer for an URL' do
      url = 'http://foo/bar'
      expect(AmpelExtase::JenkinsClient).to\
        receive(:new).with(url).and_return client
      expect(described_class).to\
        receive(:new).with(client)
      described_class.for_url url
    end

    it 'returns a null object if url was nil' do
      expect(described_class.for_url(nil)).to be_nil
    end
  end

  describe '#check' do
    it 'outputs "OK" if it can fetch data from CI' do
      allow(jso).to receive(:puts)
      expect(jso).to receive(:puts).with('OK')
      jso.check
    end

    it 'lets an exception pass if raised by the client' do
      allow(client).to receive(:fetch).and_raise e = StandardError.new
      expect { jso.check }.to raise_error e
    end
  end

  describe '#last_result' do
    it 'uses client to fetch last_completed_build' do
      allow(client).to receive(:fetch_build).with(:last_completed_build).
        and_return('result' => :foo)
      expect(jso.last_result).to eq :foo
    end
  end

  describe '#building?' do
    it 'uses client to fetch last_build' do
      allow(client).to receive(:fetch_build).with(:last_build).
        and_return('building' => :foo)
      expect(jso.building?).to eq :foo
    end
  end

  describe '#on_state_change' do
    let :bs_initial do
      AmpelExtase::BuildState.for [ 'N/A', nil ]
    end

    let :bs_success do
      AmpelExtase::BuildState.for [ 'SUCCESS', true ]
    end

    let :bs_failure do
      AmpelExtase::BuildState.for [ 'FAILURE', true ]
    end

    it 'tracks changes in build state' do
      Time.dummy(past = Time.now - 10) do
        jso
      end
      expect(jso.instance_variable_get(:@build_state)).to eq bs_initial
      expect(jso.instance_variable_get(:@state_changed_at)).to eq past
      allow(client).to receive(:fetch_build).with(:last_completed_build).
        and_return('result' => 'SUCCESS')
      allow(client).to receive(:fetch_build).with(:last_build).
        and_return('building' => true)
      expect(jso).to receive(:puts).with(
        "state changed from N/A to SUCCESS (building) => "\
        "taking action"
      )
      now = nil
      Time.dummy(Time.now) do
        expect { |b|
          jso.on_state_change(&b)
          now = Time.now
        }.to yield_with_args(bs_success)
      end
      expect(jso.instance_variable_get(:@build_state)).to eq bs_success
      expect(jso.instance_variable_get(:@state_changed_at)).to eq now
      allow(client).to receive(:fetch_build).with(:last_completed_build).
        and_return('result' => 'FAILURE')
      allow(client).to receive(:fetch_build).with(:last_build).
        and_return('building' => true)
      expect(jso).to receive(:puts).with(
        "state changed from SUCCESS (building) to FAILURE (building) => "\
        "taking action"
      )
      expect { |b| jso.on_state_change(&b) }.to yield_with_args(bs_failure)
      expect(jso.instance_variable_get(:@build_state)).to eq bs_failure
    end

    it 'notices if nothing has changed' do
      allow(client).to receive(:fetch_build).twice.with(:last_completed_build).
        and_return('result' => 'SUCCESS')
      allow(client).to receive(:fetch_build).twice.with(:last_build).
        and_return('building' => true)
      expect(jso).to receive(:puts).with(
        "state changed from N/A to SUCCESS (building) => "\
        "taking action"
      )
      expect { |b| jso.on_state_change(&b) }.to yield_with_args(bs_success)
      expect(jso.instance_variable_get(:@build_state)).to eq bs_success
      expect(jso).to receive(:puts).with(
        "state did not change, is still SUCCESS (building) => do nothing"
      )
      expect(jso.instance_variable_get(:@build_state)).to eq bs_success
      expect { |b| jso.on_state_change(&b) }.not_to yield_with_args(bs_success)
    end
  end
end
