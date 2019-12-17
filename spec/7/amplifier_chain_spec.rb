# frozen_string_literal: true

require File.join(ROOT, '7', 'amplifier_chain')

RSpec.describe Intcode7::AmplifierChain do
  let(:amplifiers) { described_class.new(memory: memory, phases: phases) }

  subject { amplifiers.call(0) }

  context 'with example 1' do
    let(:phases) { [4, 3, 2, 1, 0] }
    let(:memory) do
      [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]
    end

    it { is_expected.to eq 43210 }
  end

  context 'with example 2' do
    let(:phases) { [0, 1, 2, 3, 4] }
    let(:memory) do
      [
        3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23,
        101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0
      ]
    end

    it { is_expected.to eq 54321 }
  end

  context 'with example 3' do
    let(:phases) { [1, 0, 4, 3, 2] }
    let(:memory) do
      [
        3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33,
        1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0
      ]
    end

    it { is_expected.to eq 65210 }
  end
end
