# frozen_string_literal: true

RSpec.describe 'intcode.rb' do
  let(:intcode_rb) { File.join(ROOT, '5', 'intcode.rb') }

  subject { `#{intcode_rb} #{input_txt} <<< '#{stdin}'`.chomp }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '5', 'input.txt') }

    context 'with "1" on stdin' do
      let(:stdin) { '1' }
      it { is_expected.to include("0\n" * 9) }
      it { is_expected.to end_with '12234644' }
    end

    context 'with "5" on stdin' do
      let(:stdin) { '5' }
      it { is_expected.to eq '3508186' }
    end
  end
end
