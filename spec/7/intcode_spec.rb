# frozen_string_literal: true

RSpec.describe 'intcode.rb' do
  let(:intcode_rb) { File.join(ROOT, '7', 'intcode.rb') }

  subject { `#{intcode_rb} #{input_txt}`.chomp }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '7', 'example_1.txt') }
    it { is_expected.to include 'Max thrust 43210 (phases [4, 3, 2, 1, 0])' }
    it { is_expected.to include 'Max thrust 98765 (phases [9, 8, 7, 6, 5])' }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '7', 'input.txt') }
    it { is_expected.to include 'Max thrust 46248 (phases [1, 0, 2, 4, 3])' }
    it { is_expected.to include 'Max thrust 54163586 (phases [6, 8, 5, 9, 7])' }
  end
end
