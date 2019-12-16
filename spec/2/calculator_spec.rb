# frozen_string_literal: true

require File.join(ROOT, '2', 'calculator')

RSpec.describe Intcode::Calculator do
  let(:calculator) { described_class.new(input_file: input_txt) }

  subject(:calculation) { calculator.result(noun: noun, verb: verb) }

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '2', 'input.txt') }
    let(:noun) { 12 }
    let(:verb) { 2 }

    it { is_expected.to eq 3931283 }
  end
end
