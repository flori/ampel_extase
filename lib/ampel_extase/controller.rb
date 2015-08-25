#!/usr/bin/env ruby

require 'term/ansicolor'
require 'ampel_extase/light_switcher'
require 'ampel_extase/jenkins_state_observer'

class AmpelExtase::Controller
  include Term::ANSIColor

  def self.for(
    serial:,
    jenkins_url:,
    warning_jenkins_url: nil,
    sleep: 10
  )
    ampel_jenkins   = AmpelExtase::JenkinsStateObserver.for_url(jenkins_url)
    warning_jenkins = AmpelExtase::JenkinsStateObserver.for_url(warning_jenkins_url)
    lights = AmpelExtase::LightSwitcher.for(serial: serial)
    new(ampel_jenkins, warning_jenkins, lights, sleep: sleep)
  end

  def initialize(
    ampel_jenkins,
    warning_jenkins,
    lights,
    sleep: 10
  )
    @ampel_jenkins, @warning_jenkins, @lights, @sleep =
      ampel_jenkins, warning_jenkins, lights, sleep
    check_lights
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
    @ampel_jenkins.on_state_change do |state|
      perform_lights_switch state
    end
    @warning_jenkins.on_state_change do |state|
      perform_warning state
    end
  end

  def perform_lights_switch(state)
    case state.last_result
    when 'SUCCESS'
      @lights.green.on
      @lights.red.off
      puts success('LIGHTS SUCCESS')
    when 'FAILURE', 'ABORTED'
      @lights.red.on
      if state.building?
        @lights.green.on
        puts failure_building('LIGHTS FAILURE BUILDING')
      else
        @lights.green.off
        puts failure('LIGHTS FAILURE')
      end
    end
  end

  def perform_warning(state)
    case state.last_result
    when 'SUCCESS'
      @lights.aux.off
      puts success('WARNING SUCCESS')
    when 'FAILURE', 'ABORTED'
      if state.building?
        @lights.aux.off
        puts failure_building('WARNING FAILURE BUILDING')
      else
        @lights.aux.on
        puts failure('WARNING FAILURE')
      end
    end
  end

  def success(message)
    green message
  end

  def failure(message)
    red message
  end

  def failure_building(message)
    green on_red message
  end

  def switch_all_lights_off
    @lights.each(&:off)
  end

  def switch_all_lights_on
    @lights.each(&:on)
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
    switch_all_lights_on
    sleep 1
    switch_all_lights_off
    sleep 1
    puts "OK"
  end
end
