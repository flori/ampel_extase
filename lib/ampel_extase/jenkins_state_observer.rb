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
    @build_state = AmpelExtase::BuildState.for
    check
  end

  def check
    puts "checking jenkins configuration for #{@jenkins.url.to_s.inspect}"
    @jenkins.fetch and puts "OK"
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

  def on_state_change
    new_state = AmpelExtase::BuildState.for [ last_result, building? ]
    if state_changed?(new_state)
      puts "state changed from #@build_state to #{new_state} => taking action"
      yield new_state
    else
      puts "state did not change, is still #@build_state => do nothing"
    end
  ensure
    @build_state = new_state
  end
end
