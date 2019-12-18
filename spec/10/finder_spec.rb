# frozen_string_literal: true

RSpec.describe 'finder.rb' do
  let(:intcode_rb) { File.join(ROOT, '10', 'finder.rb') }

  subject { `#{intcode_rb} #{input_txt}`.chomp }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '10', 'input.txt') }

    it { is_expected.to include 'Best monitoring station: [37, 25]' }
    it { is_expected.to include 'Visible asteroids (309)' }
  end
end
