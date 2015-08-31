require 'ampel_extase/build_state'
require 'ampel_extase/jenkins_client'

class AmpelExtase::JenkinsStateObserver
  def self.for_url(jenkins_url)
    if jenkins_url
      jenkins = AmpelExtase::JenkinsClient.new(jenkins_url)
      new(jenkins)
    else
      Tins::NULL
    end
  end

  def initialize(jenkins)
    @jenkins = jenkins
    set_state AmpelExtase::BuildState.for
    check
  end

  def check
    puts "checking jenkins configuration for #{@jenkins.url.to_s.inspect}"
    @jenkins.fetch and puts "OK"
    self
  end

  def last_result
    @jenkins.fetch_build(:last_completed_build)['result']
  end

  def building?
    @jenkins.fetch_build(:last_build)['building']
  end

  def state_changed?(new_state)
    new_state != @build_state
  end

  def set_state(state)
    @build_state = state
    @state_changed_at = Time.now
    self
  end

  attr_reader :build_state

  attr_reader :state_changed_at

  def fetch_new_state
    AmpelExtase::BuildState.for [ last_result, building? ]
  end

  def on_state_change
    new_state = fetch_new_state
    if state_changed?(new_state)
      puts "state changed from #@build_state to #{new_state} => taking action"
      begin
        yield new_state
      ensure
        set_state new_state
      end
    else
      puts "state did not change, is still #@build_state => do nothing"
    end
    self
  end

  def expired?(duration)
    Time.now > @state_changed_at + duration
  end
end
