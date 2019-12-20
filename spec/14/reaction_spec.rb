# frozen_string_literal: true

require File.join(ROOT, '14', 'reaction')

RSpec.describe NanoFactory::Reaction do
  describe '.parse' do
    subject(:reaction) { described_class.parse(string) }

    context 'with a reaction from example 1' do
      let(:string) { '10 ORE => 10 A' }
      its(:reactants) { is_expected.to eq(ORE: 10) }
      its(:product) { is_expected.to eq(A: 10) }
    end

    context 'with a reaction requiring multiple reactants from example 1' do
      let(:string) { '3 A, 4 B => 1 AB' }
      its(:reactants) { is_expected.to eq(A: 3, B: 4) }
      its(:product) { is_expected.to eq(AB: 1) }
    end

    context 'with a reaction requiring three reactants from example 1' do
      let(:string) { '2 AB, 3 BC, 4 CA => 1 FUEL' }
      its(:reactants) { is_expected.to eq(AB: 2, BC: 3, CA: 4) }
      its(:product) { is_expected.to eq(FUEL: 1) }
    end
  end
end
