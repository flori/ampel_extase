require 'spec_helper'

describe AmpelExtase::JenkinsWarningStateObserver do
  let :jenkins_warning_state_observer do
    described_class.new [ observer ]
  end

  let :client do
    double('AmpelExtase::JenkinsClient', url: 'http://foo/bar')
  end

  let :observer do
    AmpelExtase::JenkinsStateObserver.new client
  end

  before do
    allow(client).to receive(:fetch).and_return true
    allow_any_instance_of(AmpelExtase::JenkinsStateObserver).to receive(:puts)
    allow_any_instance_of(AmpelExtase::JenkinsClient).to receive(:puts)
  end

  describe '.for_urls' do
    it 'returns a null object if there were no URLs passed' do
      expect(described_class.for_urls).to be_nil
    end

    it 'creates a jenkins_state_observer for every URL passed' do
      expect(AmpelExtase::JenkinsStateObserver).to receive(:for_url).with('foo')
      expect(AmpelExtase::JenkinsStateObserver).to receive(:for_url).with('bar')
      described_class.for_urls 'foo', 'bar'
    end
  end

  describe '#check' do
    it 'delegates the check to its observers' do
      expect(observer).to receive(:check)
      jenkins_warning_state_observer.check
    end
  end

  describe '#on_state_change' do
    let :bs_success do
      AmpelExtase::BuildState.for [ 'SUCCESS', true ]
    end

    let :bs_failure do
      AmpelExtase::BuildState.for [ 'FAILURE', true ]
    end

    it 'delegates on_state_change to observers' do
      expect(observer).to receive(:on_state_change)
      jenkins_warning_state_observer.on_state_change(666)
    end

    it 'executes state change action on FAILURE/ABORTED result' do
      allow(observer).to receive(:fetch_new_state).and_return bs_failure
      executed = false
      jenkins_warning_state_observer.on_state_change(666) do
        executed = true
      end
      expect(executed).to eq true
    end

    it 'skips states where the last result is not FAILURE/ABORTED' do
      allow(observer).to receive(:fetch_new_state).and_return bs_success
      executed = false
      jenkins_warning_state_observer.on_state_change(666) do
        executed = true
      end
      expect(executed).to eq false
    end
  end

  describe '#expired?' do
    it 'checks if all of its observers are expired' do
      expect(jenkins_warning_state_observer).to receive(:last_failure_at).and_return Time.now - 666
      expect(jenkins_warning_state_observer).to be_expired(60)
    end
  end
end
