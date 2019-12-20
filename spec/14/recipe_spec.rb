# frozen_string_literal: true

require File.join(ROOT, '14', 'recipe')

RSpec.describe NanoFactory::Recipe do
  let(:target) { { FUEL: 1 } }
  subject(:recipe) { described_class.load(input_txt, target: target) }

  let(:reaction_class) { NanoFactory::Reaction }

  context 'with example 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '14', 'example_1.txt') }
    its(:ore_for_target) { is_expected.to eq 31 }
    its(:reactions) do
      is_expected.to eq [
        reaction_class.new({ ORE: 10 }, A: 10),
        reaction_class.new({ ORE: 1 }, B: 1),
        reaction_class.new({ A: 7, B: 1 }, C: 1),
        reaction_class.new({ A: 7, C: 1 }, D: 1),
        reaction_class.new({ A: 7, D: 1 }, E: 1),
        reaction_class.new({ A: 7, E: 1 }, FUEL: 1)
      ]
    end
  end

  context 'with example 2' do
    let(:input_txt) { File.join(ROOT, 'spec', '14', 'example_2.txt') }
    its(:ore_for_target) { is_expected.to eq 165 }
    its(:reactions) do
      is_expected.to eq [
        reaction_class.new({ ORE: 9}, A: 2),
        reaction_class.new({ ORE: 8}, B: 3),
        reaction_class.new({ ORE: 7}, C: 5),
        reaction_class.new({ A: 3, B: 4 }, AB: 1),
        reaction_class.new({ B: 5, C: 7 }, BC: 1),
        reaction_class.new({ C: 4, A: 1 }, CA: 1),
        reaction_class.new({ AB: 2, BC: 3, CA: 4 }, FUEL: 1)
      ]
    end
  end

  context 'with example 3' do
    let(:input_txt) { File.join(ROOT, 'spec', '14', 'example_3.txt') }
    its(:ore_for_target) { is_expected.to eq 13_312 }
  end

  context 'with example 4' do
    let(:input_txt) { File.join(ROOT, 'spec', '14', 'example_4.txt') }
    its(:ore_for_target) { is_expected.to eq 180_697 }
  end

  context 'with example 5' do
    let(:input_txt) { File.join(ROOT, 'spec', '14', 'example_5.txt') }
    its(:ore_for_target) { is_expected.to eq 2_210_736 }
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '14', 'input.txt') }
    its(:ore_for_target) { is_expected.to eq 1_582_325 }
  end
end
