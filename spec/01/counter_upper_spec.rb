# frozen_string_literal: true

RSpec.describe 'counter_upper.rb' do
  let(:counter_upper_rb) { File.join(ROOT, '1', 'counter_upper.rb') }

  subject { `#{counter_upper_rb} #{input_txt}` }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '1', 'example_1.txt') }
    it { is_expected.to include 'Fuel required for modules: 2' }
    it { is_expected.to include 'Total fuel required: 2' }
  end

  context 'with example input 2' do
    let(:input_txt) { File.join(ROOT, 'spec', '1', 'example_2.txt') }
    it { is_expected.to include 'Fuel required for modules: 2' }
    it { is_expected.to include 'Total fuel required: 2' }
  end

  context 'with example input 3' do
    let(:input_txt) { File.join(ROOT, 'spec', '1', 'example_3.txt') }
    it { is_expected.to include 'Fuel required for modules: 654' }
    it { is_expected.to include 'Total fuel required: 966' }
  end

  context 'with example input 4' do
    let(:input_txt) { File.join(ROOT, 'spec', '1', 'example_4.txt') }
    it { is_expected.to include 'Fuel required for modules: 33583' }
    it { is_expected.to include 'Total fuel required: 50346' }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '1', 'input.txt') }
    it { is_expected.to include 'Fuel required for modules: 3512133' }
    it { is_expected.to include 'Total fuel required: 5265294' }
  end
end
