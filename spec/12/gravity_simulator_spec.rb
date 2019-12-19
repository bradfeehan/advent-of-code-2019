# frozen_string_literal: true

require File.join(ROOT, '12', 'gravity_simulator')

RSpec.describe GravitySimulator do
  subject(:simulator) { described_class.from_txt(input_txt) }
  before { steps.times { simulator.step } }
  let(:steps) { 0 }

  context 'with example input 1' do
    let(:input_txt) { File.join(ROOT, 'spec', '12', 'example_1.txt') }
    its(:total_period) { is_expected.to eq 2772 }

    it 'has the correct X period' do
      expect(simulator.period(:x)).to eq 18
    end

    it 'has the correct Y period' do
      expect(simulator.period(:y)).to eq 28
    end

    it 'has the correct Z period' do
      expect(simulator.period(:z)).to eq 44
    end

    context 'after one step' do
      let(:steps) { 1 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(2, -1, 1), Vector3D.new(3, -1, -1)),
          Body.new(Vector3D.new(3, -7, -4), Vector3D.new(1, 3, 3)),
          Body.new(Vector3D.new(1, -7, 5), Vector3D.new(-3, 1, -3)),
          Body.new(Vector3D.new(2, 2, 0), Vector3D.new(-1, -3, 1))
        ]
      end
    end

    context 'after two steps' do
      let(:steps) { 2 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(5, -3, -1), Vector3D.new(3, -2, -2)),
          Body.new(Vector3D.new(1, -2, 2), Vector3D.new(-2, 5, 6)),
          Body.new(Vector3D.new(1, -4, -1), Vector3D.new(0, 3, -6)),
          Body.new(Vector3D.new(1, -4, 2), Vector3D.new(-1, -6, 2))
        ]
      end
    end

    context 'after three steps' do
      let(:steps) { 3 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(5, -6, -1), Vector3D.new(0, -3, 0)),
          Body.new(Vector3D.new(0, 0, 6), Vector3D.new(-1, 2, 4)),
          Body.new(Vector3D.new(2, 1, -5), Vector3D.new(1, 5, -4)),
          Body.new(Vector3D.new(1, -8, 2), Vector3D.new(0, -4, 0))
        ]
      end
    end

    context 'after four steps' do
      let(:steps) { 4 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(2, -8, 0), Vector3D.new(-3, -2, 1)),
          Body.new(Vector3D.new(2, 1, 7), Vector3D.new(2, 1, 1)),
          Body.new(Vector3D.new(2, 3, -6), Vector3D.new(0, 2, -1)),
          Body.new(Vector3D.new(2, -9, 1), Vector3D.new(1, -1, -1))
        ]
      end
    end

    context 'after ten steps' do
      let(:steps) { 10 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(2, 1, -3), Vector3D.new(-3, -2, 1)),
          Body.new(Vector3D.new(1, -8, 0), Vector3D.new(-1, 1, 3)),
          Body.new(Vector3D.new(3, -6, 1), Vector3D.new(3, 2, -3)),
          Body.new(Vector3D.new(2, 0, 4), Vector3D.new(1, -1, -1))
        ]
      end
      its(:total_energy) { is_expected.to eq 179 }
    end

    context 'after 2772 steps' do
      let(:steps) { 2772 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(-1, 0, 2)),
          Body.new(Vector3D.new(2, -10, -7)),
          Body.new(Vector3D.new(4, -8, 8)),
          Body.new(Vector3D.new(3, 5, -1))
        ]
      end
    end
  end

  context 'with example input 2' do
    let(:input_txt) { File.join(ROOT, 'spec', '12', 'example_2.txt') }
    its(:total_period) { is_expected.to eq 4686774924 }

    it 'has the correct X period' do
      expect(simulator.period(:x)).to eq 2028
    end

    it 'has the correct Y period' do
      expect(simulator.period(:y)).to eq 5898
    end

    it 'has the correct Z period' do
      expect(simulator.period(:z)).to eq 4702
    end

    context 'after ten steps' do
      let(:steps) { 10 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(-9, -10, 1), Vector3D.new(-2, -2, -1)),
          Body.new(Vector3D.new(4, 10, 9), Vector3D.new(-3, 7, -2)),
          Body.new(Vector3D.new(8, -10, -3), Vector3D.new(5, -1, -2)),
          Body.new(Vector3D.new(5, -10, 3), Vector3D.new(0, -4, 5))
        ]
      end
    end

    context 'after 100 steps' do
      let(:steps) { 100 }
      its(:bodies) do
        is_expected.to eq [
          Body.new(Vector3D.new(8, -12, -9), Vector3D.new(-7, 3, 0)),
          Body.new(Vector3D.new(13, 16, -3), Vector3D.new(3, -11, -5)),
          Body.new(Vector3D.new(-29, -11, -1), Vector3D.new(-3, 7, 4)),
          Body.new(Vector3D.new(16, -13, 23), Vector3D.new(7, 1, 1))
        ]
      end
      its(:total_energy) { is_expected.to eq 1940 }
    end
  end

  context 'with puzzle input' do
    let(:input_txt) { File.join(ROOT, '12', 'input.txt') }
    its(:total_period) { is_expected.to eq 318_382_803_780_324 }

    context 'after 1000 steps' do
      let(:steps) { 1_000 }
      its(:total_energy) { is_expected.to eq 9958 }
    end
  end
end
