# frozen_string_literal: true

RSpec.describe 'intcode.rb' do
  let(:intcode_rb) { File.join(ROOT, '2', 'intcode.rb') }

  subject { `#{intcode_rb} #{input_txt}` }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '2', 'input.txt') }
    it { is_expected.to include 'noun=69, verb=79: result=19690720' }
  end
end
