require 'spec_helper'

describe AmpelExtase::BuildState do
  describe 'initial state' do
    let :bs do
      described_class.for
    end

    it 'has a to_a' do
      expect(bs.to_a).to eq [ 'N/A', nil ]
    end

    it 'has N/A as the last result' do
      expect(bs.last_result).to eq 'N/A'
    end

    it 'does not build atm' do
      expect(bs.building?).to eq false
    end

    it 'reads N/A as a string' do
      expect(bs.to_s).to eq 'N/A'
    end

    it 'is a success, provisionally' do
      expect(bs).to be_success
    end
  end

  describe 'a success state' do
    let :bs do
      described_class.for [ 'SUCCESS', true ]
    end

    it 'has SUCCESS as the last result' do
      expect(bs.last_result).to eq 'SUCCESS'
    end

    it 'is a success' do
      expect(bs).to be_success
    end

    describe 'building' do
      it 'has a to_a' do
        expect(bs.to_a).to eq [ 'SUCCESS', true ]
      end

      it 'can be building' do
        expect(bs.building?).to eq true
      end

      it 'reads SUCCESS (building) as a string' do
        expect(bs.to_s).to eq 'SUCCESS (building)'
      end
    end

    describe 'not building' do
      let :bs do
        described_class.for [ 'SUCCESS', false ]
      end

      it 'has a to_a' do
        expect(bs.to_a).to eq [ 'SUCCESS', false ]
      end

      it 'can not be building' do
        expect(bs.building?).to eq false
      end

      it 'reads SUCCESS (building) as a string' do
        expect(bs.to_s).to eq 'SUCCESS'
      end
    end
  end

  describe 'a failed state' do
    let :bs do
      described_class.for [ 'FAILURE', true ]
    end

    it 'is not a success' do
      expect(bs).not_to be_success
    end
  end

  describe 'equality' do
    it 'can be equal or unequal' do
      foo_true = described_class.for([ 'FOO', true ])
      foo_false = described_class.for([ 'FOO', false ])
      bar_true = described_class.for([ 'BAR', true ])
      expect(foo_true).to eq described_class.for([ 'FOO', true ])
      expect(foo_true).not_to eq foo_false
      expect(foo_true).not_to eq bar_true
    end
  end
end
