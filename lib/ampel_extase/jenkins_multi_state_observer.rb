require 'ampel_extase/jenkins_state_observer'

class AmpelExtase::JenkinsMultiStateObserver
  def self.for_urls(*jenkins_urls)
    new jenkins_urls.map { |jenkins_url| AmpelExtase::JenkinsStateObserver.new(jenkins_url) }
  end

  def initialize(observers)
    @observers = observers
  end

  def check
    @observers.each(&:check)
  end

  def on_state_change(&block)
    @observers.each do |o|
      o.on_state_change(&block)
    end
  end
end
