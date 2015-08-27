require 'spec_helper'

describe AmpelExtase::JenkinsWarningStateObserver do
  let :jenkins_warning_state_observer do
    described_class.new [ observer ]
  end

  let :observer do
    double('AmpelExtase::JenkinsStateObserver')
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

    it 'skips observers that are already expired b4 duration' do
      expect(observer).to receive(:expired?).with(666).and_return true
      expect(observer).not_to receive(:on_state_change)
      jenkins_warning_state_observer.on_state_change(666)
    end

    it 'skips states where the last result is not FAILURE/ABORTED' do
      expect(observer).to receive(:expired?).with(666).and_return false
      allow(observer).to receive(:on_state_change)
      jenkins_warning_state_observer.on_state_change(666)
    end
  end

  describe '#expired?' do
    it 'checks if all of its observers are expired' do
      expect(observer).to receive(:expired?).with(666)
      jenkins_warning_state_observer.expired?(666)
    end
  end
end

