# frozen_string_literal: true

RSpec.describe 'intcode.rb' do
  let(:intcode_rb) { File.join(ROOT, '9', 'intcode.rb') }

  subject { `#{intcode_rb} #{input_txt} <<< '#{stdin}'`.chomp }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '9', 'input.txt') }

    context 'with "1" on stdin' do
      let(:stdin) { '1' }
      # it { is_expected.to include("0\n" * 9) }
      it { is_expected.to eq '3013554615' }
    end

    context 'with "2" on stdin' do
      let(:stdin) { '2' }
      it { is_expected.to eq '50158' }
    end
  end
end
