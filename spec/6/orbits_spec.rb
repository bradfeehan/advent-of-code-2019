# frozen_string_literal: true

RSpec.describe 'orbits.rb' do
  let(:orbits_rb) { File.join(ROOT, '6', 'orbits.rb') }

  subject { `#{orbits_rb} #{input_txt}` }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '6', 'example_1.txt') }
    it { is_expected.to include 'Total orbits: 42' }
  end

  context 'with example input 2' do
    let(:input_txt) { File.join(ROOT, 'spec', '6', 'example_2.txt') }
    it { is_expected.to include 'Transit 4; path: [:J, :E, :D, :I]' }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '6', 'input.txt') }
    it { is_expected.to include 'Total orbits: 314702' }
    it { is_expected.to include 'Transit 439' }
  end
end
