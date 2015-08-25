require 'spec_helper'

describe AmpelExtase::LightSwitcher do
  let :port do
    double('SocketSwitcher::Port')
  end

  let :switcher do
    allow(SocketSwitcher::Port).to receive(:new).and_return port
    described_class.for serial: 'foo/bar'
  end

  describe '#green' do
    it 'returns device 0' do
      expect(port).to receive(:device).with(0)
      switcher.green
    end
  end

  describe '#red' do
    it 'returns device 1' do
      expect(port).to receive(:device).with(1)
      switcher.red
    end
  end

  describe '#aux' do
    it 'returns device 3' do
      expect(port).to receive(:device).with(2)
      switcher.aux
    end
  end

  describe '#each' do
    it 'iterates over all port devices' do
      expect(port).to receive(:device).thrice.and_return :ok
      expect(switcher.each.to_a).to eq %i[ ok ] * 3
    end
  end
end
