# frozen_string_literal: true

RSpec.describe 'intcode.rb' do
  let(:intcode_rb) { File.join(ROOT, '7', 'intcode.rb') }

  subject { `#{intcode_rb} #{input_txt}`.chomp }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '7', 'example_1.txt') }
    it { is_expected.to eq 'Max thrust 43210 (phases [4, 3, 2, 1, 0])' }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '7', 'input.txt') }
    it { is_expected.to eq 'Max thrust 46248 (phases [1, 0, 2, 4, 3])' }
  end
end
