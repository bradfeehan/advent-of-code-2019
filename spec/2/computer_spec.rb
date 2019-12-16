# frozen_string_literal: true

require File.join(ROOT, '2', 'computer')

RSpec.describe Intcode::Computer do
  let(:computer) { described_class.new(initial_memory) }

  before { computer.run }

  subject(:output) { computer.memory }

  context 'with example 1' do
    let(:initial_memory) { [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50] }
    it { is_expected.to eq [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50] }
  end

  context 'with example 2' do
    let(:initial_memory) { [1, 0, 0, 0, 99] }
    it { is_expected.to eq [2, 0, 0, 0, 99] }
  end

  context 'with example 3' do
    let(:initial_memory) { [2, 3, 0, 3, 99] }
    it { is_expected.to eq [2, 3, 0, 6, 99] }
  end

  context 'with example 4' do
    let(:initial_memory) { [2, 4, 4, 5, 99, 0] }
    it { is_expected.to eq [2, 4, 4, 5, 99, 9801] }
  end

  context 'with example 5' do
    let(:initial_memory) { [1, 1, 1, 4, 99, 5, 6, 0, 99] }
    it { is_expected.to eq [30, 1, 1, 4, 2, 5, 6, 0, 99] }
  end
end
