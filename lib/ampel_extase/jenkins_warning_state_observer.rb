require 'ampel_extase/jenkins_state_observer'

class AmpelExtase::JenkinsWarningStateObserver
  def self.for_urls(*jenkins_urls)
    if urls = jenkins_urls.full?
      new urls.map { |jenkins_url|
        AmpelExtase::JenkinsStateObserver.for_url(jenkins_url)
      }
    else
      Tins::NULL
    end
  end

  def initialize(observers)
    @observers = observers
  end

  def reset
    @observers.each(&:reset)
  end

  def check
    @observers.each(&:check)
  end

  def on_state_change(duration, &block)
    @observers.each do |observer|
      observer.on_state_change do |state|
        if %w[ FAILURE ABORTED ].include?(state.last_result)
          block.(state)
          return
        end
      end
    end
    self
  end

  def last_failure_at
    @observers.reject { |o| o.build_state.success? }.
      map(&:state_changed_at).max || Time.at(0)
  end

  def expired?(duration)
    Time.now - last_failure_at > duration
  end
end
