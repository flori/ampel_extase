require 'spec_helper'

describe AmpelExtase::Controller do
  before do
    allow_any_instance_of(AmpelExtase::JenkinsClient).to receive(:puts)
    allow_any_instance_of(AmpelExtase::SemaphoreClient).to receive(:puts)
    allow_any_instance_of(described_class).to receive(:puts)
    allow_any_instance_of(AmpelExtase::SemaphoreStateObserver).to receive(:puts)
    allow_any_instance_of(AmpelExtase::JenkinsStateObserver).to receive(:puts)
    allow_any_instance_of(described_class).to receive(:sleep)
  end

  let :ampel_client do
    double('AmpelExtase::SemaphoreClient', url: 'http://foo/bar')
  end

  let :warning_client1 do
    double('AmpelExtase::JenkinsClient', url: 'http://foo/bar')
  end

  let :warning_client2 do
    double('AmpelExtase::JenkinsClient', url: 'http://foo/bar')
  end

  let :ampel_semaphore do
    AmpelExtase::SemaphoreStateObserver.new ampel_client
  end

  let :warning_jenkins1 do
    AmpelExtase::SemaphoreStateObserver.new(warning_client1)
  end

  let :warning_jenkins2 do
    AmpelExtase::SemaphoreStateObserver.new(warning_client2)
  end

  let :warning_jenkins do
    AmpelExtase::JenkinsWarningStateObserver.new [
      warning_jenkins1, warning_jenkins2
    ]
  end

  let :lights do
    double('AmpelExtase::LightSwitcher')
  end

  let :controller do
    described_class.new(
      ampel_semaphore,
      warning_jenkins,
      lights
    )
  end

  before do
    for client in [ ampel_client, warning_client1, warning_client2 ]
      allow(client).to receive(:fetch).and_return true
      allow(client).to receive(:fetch_build).and_return('result' => 'N/A')
    end
  end

  before do
    allow(lights).to receive(:each)
  end

  describe '.for' do
    it 'can create a demo object that does not really do anything' do
      demo_object = described_class.for(
        serial: nil,
        semaphore_url: nil
      )
      expect(demo_object.instance_eval { @ampel_semaphore }).to be_nil
      expect(demo_object.instance_eval { @warning_jenkins }).to be_nil
      expect(demo_object.instance_eval { @lights }).to be_nil
    end
  end

  describe '#start' do
    it 'performs and then sleeps' do
      allow(controller).to receive(:sleep).and_raise(
        sleep_error = StandardError.new
      )
      allow(controller).to receive(:at_exit)
      expect(controller).to receive(:perform)
      expect { controller.start }.to raise_error sleep_error
    end

    it 'can handle crashes' do
      allow(controller).to receive(:sleep).and_raise(
        sleep_error = StandardError.new
      )
      allow(controller).to receive(:at_exit)
      expect(controller).to receive(:perform).and_raise(e = StandardError.new)
      expect(controller).to receive(:handle_crash).with(e)
      expect { controller.start }.to raise_error sleep_error
    end

  end

  describe '#stop' do
    before do
      controller
    end

    it 'iterates over all lights' do
      expect(lights).to receive(:each).once
      controller.stop
    end
  end

  describe '#perform' do
    let :perform do
      controller.instance_eval { perform }
    end

    let :lights do
      double('Lights', aux: double('Device', on: true, off: true))
    end

    before do
      controller.instance_variable_set :@lights, lights
    end

    it 'reacts to state changes' do
      state = AmpelExtase::BuildState.for [ 'passed', false ]
      allow(ampel_semaphore).to receive(:fetch_new_state).and_return state
      expect { |b| ampel_semaphore.on_state_change(&b) }.to yield_with_args(state)
      perform
    end
  end

  describe '#handle_crash' do
    let :exception do
      raise StandardError rescue $!
    end

    let :handle_crash do
      my_exception = exception
      controller.instance_eval { handle_crash(my_exception) }
    end

    before do
      controller
      allow(controller).to receive(:warn)
    end

    it 'warns on crash' do
      expect(controller).to receive(:warn).with(/^Caught/)
      handle_crash
    end

    it 'switches the lights of once' do
      expect(controller).to receive(:switch_all_lights_off)
      handle_crash
      expect(controller).not_to receive(:switch_all_lights_off)
      handle_crash
    end
  end

  describe '#perform_lights_switch' do
    before do
      controller.instance_variable_set :@lights, Tins::NULL
    end

    let :perform_lights_switch do
      my_state = state
      controller.instance_eval { perform_lights_switch(my_state) }
    end

    context 'success' do
      let :state do
        AmpelExtase::BuildState.for [ 'SUCCESS', false ]
      end

      it 'goes green on success' do
        expect(controller).to receive(:success).and_call_original
        perform_lights_switch
      end
    end

    context 'failure' do
      let :state do
        AmpelExtase::BuildState.for [ 'FAILURE', false ]
      end

      it 'goes red on failure' do
        expect(controller).to receive(:failure).and_call_original
        perform_lights_switch
      end
    end

    context 'failure building' do
      let :state do
        AmpelExtase::BuildState.for [ 'FAILURE', true ]
      end

      it 'goes green on red on failure and building' do
        expect(controller).to receive(:failure_building).and_call_original
        perform_lights_switch
      end
    end
  end

  describe '#perform_warning' do
    before do
      controller.instance_variable_set :@lights, Tins::NULL
    end

    let :perform_warning do
      my_state = state
      controller.instance_eval { perform_warning(my_state) }
    end

    context 'success' do
      let :state do
        AmpelExtase::BuildState.for [ 'SUCCESS', false ]
      end

      it 'goes green on success' do
        expect(controller).to receive(:success).and_call_original
        perform_warning
      end
    end

    context 'failure' do
      let :state do
        AmpelExtase::BuildState.for [ 'FAILURE', false ]
      end

      it 'goes red on failure' do
        expect(controller).to receive(:failure).and_call_original
        perform_warning
      end
    end

    context 'failure building' do
      let :state do
        AmpelExtase::BuildState.for [ 'FAILURE', true ]
      end

      it 'goes green on red on failure and building' do
        expect(controller).to receive(:failure_building).and_call_original
        perform_warning
      end
    end
  end

  describe '#expire_warning' do
    let :aux do
      double('Device', on: true)
    end

    before do
      controller.instance_variable_set :@lights, double('Lights', aux: aux)
    end

    let :expire_warning do
      controller.instance_eval { expire_warning }
    end

    it 'expires warnings after some time' do
      allow(controller.instance_variable_get(:@warning_jenkins)).to\
        receive(:expired?).and_return true
      expect(aux).to receive(:off)
      expect(controller).to receive(:info).with('WARNING EXPIRED').and_call_original
      expire_warning
    end
  end
end
