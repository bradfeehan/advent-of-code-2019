# frozen_string_literal: true

RSpec.describe 'wires.rb' do
  let(:wires_rb) { File.join(ROOT, '3', 'wires.rb') }

  subject { `#{wires_rb} #{input_txt}` }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '3', 'example_1.txt') }
    it { is_expected.to include '(155, 4), Manhattan distance: 159' }
    it { is_expected.to include 'total: 610' }
  end

  context 'with example input 2' do
    let(:input_txt) { File.join(ROOT, 'spec', '3', 'example_2.txt') }
    it { is_expected.to include '(124, 11), Manhattan distance: 135' }
    it { is_expected.to include 'total: 410' }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '3', 'input.txt') }
    it { is_expected.to include '(970, 1159), Manhattan distance: 2129' }
    it { is_expected.to include 'total: 134662' }
  end
end
