require 'spec_helper'

describe AmpelExtase::SemaphoreClient do
  before do
    allow_any_instance_of(described_class).to receive(:puts)
  end

  let :semaphore_url do
    'https://semaphoreci.com/api/v1/projects/uuid/master?auth_token=foobar'
  end

  let :client do
    described_class.new semaphore_url
  end

  let :opened_uri do
    double('URI', read: '{"hello":"world"}')
  end

  describe '#fetch' do
    it 'can fetch JSON data from CI' do
      expect(client).to receive(:open).with(semaphore_url).and_return opened_uri
      expect(client.fetch).to eq("hello" => "world")
    end

    it 'modifies exception messages and reraises' do
      expect(client).to receive(:open).with(semaphore_url).and_raise(StandardError)
      expect { client.fetch }.to raise_error(StandardError)
    end
  end
end
