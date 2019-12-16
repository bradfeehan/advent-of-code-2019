# frozen_string_literal: true

RSpec.describe 'password.rb' do
  let(:password_rb) { File.join(ROOT, '4', 'password.rb') }

  subject { `#{password_rb} #{input_txt}` }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '4', 'input.txt') }
    it { is_expected.to include 'Part 1: 1864 candidates' }
    it { is_expected.to include 'Part 2: 1258 candidates' }
  end
end
