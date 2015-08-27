require 'spec_helper'

describe AmpelExtase::JenkinsClient do
  before do
    allow_any_instance_of(described_class).to receive(:puts)
  end

  let :client do
    described_class.new 'http://foo/bar'
  end

  let :opened_uri do
    double('URI', read: '{"hello":"world"}')
  end

  describe '#fetch' do
    let :api_url do
      'http://foo/bar/api/json'
    end

    it 'can fetch JSON data from CI' do
      expect(client).to receive(:open).with(api_url).
        and_return opened_uri
      expect(client.fetch).to eq("hello" => "world")
    end

    it 'modifies exception messages and reraises' do
      expect(client).to receive(:open).with(api_url).
        and_raise e = StandardError.new('foo')
      expect { client.fetch }.to raise_error(
        StandardError, /for #{api_url.inspect}/
      )
    end
  end

  describe '#fetch_build' do
    let :api_url do
      'http://foo/bar/buildType/api/json'
    end

    it 'can can fetch a build type responding to #to_s' do
      expect(client).to receive(:open).with(api_url).and_return opened_uri
      client.fetch_build double(to_s: 'buildType')
    end

    it 'can interpret a build type symbol correctly' do
      expect(client).to receive(:open).with(api_url).and_return opened_uri
      client.fetch_build :build_type
    end
  end
end
