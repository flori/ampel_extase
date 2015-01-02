#!/usr/bin/env ruby

require 'ampel_extase/jenkins_client'
require 'ampel_extase/light_switcher'
require 'ampel_extase/build_state'

class AmpelExtase::Controller
  def initialize(serial, jenkins_url, debug: false, sleep: 10)
    @jenkins = AmpelExtase::JenkinsClient.new(jenkins_url, debug: debug)
    check_jenkins
    @lights   = AmpelExtase::LightSwitcher.new(serial, debug: debug)
    check_lights
    @sleep = sleep
    @build_state = AmpelExtase::BuildState.for
  end

  def start
    puts "starting controller loop"
    at_exit { stop }
    loop do
      begin
        perform
      rescue => e
        handle_crash e
      end
      sleep_duration
    end
  end

  def stop
    switch_all_lights_off
    self
  end

  private

  def sleep_duration
    puts "sleep for #@sleep seconds"
    sleep @sleep
  end

  def perform
    @crashed = false
    on_state_change do |state|
      perform_switch state
    end
  end

  def perform_switch(state)
    case state.last_result
    when 'SUCCESS'
      @lights.green.on
      @lights.red.off
    when 'FAILURE', 'ABORTED'
      @lights.red.on
      if state.building?
        @lights.green.on
      else
        @lights.green.off
      end
    end
  end

  def on_state_change
    new_state = AmpelExtase::BuildState.for [ last_result, building? ]
    if new_state == @build_state
      puts "state did not change, is still #@build_state => do nothing"
    else
      puts "state changed from #@build_state to #{new_state} => taking action"
      yield new_state
    end
  ensure
    @build_state = new_state
  end

  def last_result
    @jenkins.fetch_build(:last_completed_build)['result']
  end

  def building?
    @jenkins.fetch_build(:last_build)['building']
  end

  def switch_all_lights_off
    for light in @lights
      light.off
    end
  end

  def handle_crash(exception)
    warn "Caught: #{exception.class}: #{exception}\n#{exception.backtrace * ?\n}"
    return if @crashed
    switch_all_lights_off
  rescue
  ensure
    @crashed = true
  end

  def check_lights
    puts "checking lights configuration"
    for light in @lights
      light.on
    end
    sleep 1
    for light in @lights
      light.off
    end
    sleep 1
    puts "OK"
  end

  def check_jenkins
    puts "checking jenkins configuration"
    @jenkins.fetch and puts "OK"
  end
end
