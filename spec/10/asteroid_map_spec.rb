# frozen_string_literal: true

require File.join(ROOT, '10', 'asteroid_map')

RSpec.describe AsteroidMap do
  subject(:map) { described_class.new(input_txt, strategy: strategy) }

  context 'using ShadowStrategy' do
    let(:strategy) { :shadow }

    context 'with example input 1' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_1.txt') }
      its(:rows) { is_expected.to eq 5 }
      its(:columns) { is_expected.to eq 5 }
      its(:monitoring_station) { is_expected.to eq [3, 4] }
      its(:visible_from_monitoring_station) { is_expected.to have(8).items }
      its(:asteroids) { is_expected.to have(10).items }
      its(:asteroids) do
        is_expected.to contain_exactly(
          [1, 0], [4, 0], [0, 2], [1, 2], [2, 2],
          [3, 2], [4, 2], [4, 3], [3, 4], [4, 4]
        )
      end

      its(:asteroids_with_visible) { is_expected.to have(10).items }
      its(:asteroids_with_visible) do
        is_expected.to contain_exactly(
          [[1, 0], [[4, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [4, 4]]],
          [[4, 0], [[1, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [3, 4]]],
          [[0, 2], [[1, 0], [4, 0], [1, 2], [4, 3], [3, 4], [4, 4]]],
          [[1, 2], [[1, 0], [4, 0], [0, 2], [2, 2], [4, 3], [3, 4], [4, 4]]],
          [[2, 2], [[1, 0], [4, 0], [1, 2], [3, 2], [4, 3], [3, 4], [4, 4]]],
          [[3, 2], [[1, 0], [4, 0], [2, 2], [4, 2], [4, 3], [3, 4], [4, 4]]],
          [[4, 2], [[1, 0], [4, 0], [3, 2], [4, 3], [3, 4]]],
          [[4, 3], [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [3, 4], [4, 4]]],
          [
            [3, 4],
            [[4, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [4, 3], [4, 4]]
          ],
          [[4, 4], [[1, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 3], [3, 4]]]
        )
      end
    end

    context 'with example input 2' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_2.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(40).items }
      its(:monitoring_station) { is_expected.to eq [5, 8] }
      its(:visible_from_monitoring_station) { is_expected.to have(33).items }
    end

    context 'with example input 3' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_3.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(40).items }
      its(:monitoring_station) { is_expected.to eq [1, 2] }
      its(:visible_from_monitoring_station) { is_expected.to have(35).items }
    end

    context 'with example input 4' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_4.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(50).items }
      its(:monitoring_station) { is_expected.to eq [6, 3] }
      its(:visible_from_monitoring_station) { is_expected.to have(41).items }
    end

    context 'with example input 5' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_5.txt') }
      its(:rows) { is_expected.to eq 20 }
      its(:columns) { is_expected.to eq 20 }
      its(:asteroids) { is_expected.to have(300).items }
      its(:monitoring_station) { is_expected.to eq [11, 13] }
      its(:visible_from_monitoring_station) { is_expected.to have(210).items }
    end

    context 'with puzzle input' do
      let(:input_txt) { File.join(ROOT, '10', 'input.txt') }
      its(:rows) { is_expected.to eq 48 }
      its(:columns) { is_expected.to eq 48 }
      its(:asteroids) { is_expected.to have(346).items }
      its(:monitoring_station) { is_expected.to eq [37, 25] }
      its(:visible_from_monitoring_station) { is_expected.to have(309).items }
    end
  end

  context 'using BlockerStrategy' do
    let(:strategy) { :blocker }

    context 'with example input 1' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_1.txt') }
      its(:rows) { is_expected.to eq 5 }
      its(:columns) { is_expected.to eq 5 }
      its(:monitoring_station) { is_expected.to eq [3, 4] }
      its(:visible_from_monitoring_station) { is_expected.to have(8).items }
      its(:asteroids) { is_expected.to have(10).items }
      its(:asteroids) do
        is_expected.to contain_exactly(
          [1, 0], [4, 0], [0, 2], [1, 2], [2, 2],
          [3, 2], [4, 2], [4, 3], [3, 4], [4, 4]
        )
      end

      its(:asteroids_with_visible) { is_expected.to have(10).items }
      its(:asteroids_with_visible) do
        is_expected.to contain_exactly(
          [[1, 0], [[4, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [4, 4]]],
          [[4, 0], [[1, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [3, 4]]],
          [[0, 2], [[1, 0], [4, 0], [1, 2], [4, 3], [3, 4], [4, 4]]],
          [[1, 2], [[1, 0], [4, 0], [0, 2], [2, 2], [4, 3], [3, 4], [4, 4]]],
          [[2, 2], [[1, 0], [4, 0], [1, 2], [3, 2], [4, 3], [3, 4], [4, 4]]],
          [[3, 2], [[1, 0], [4, 0], [2, 2], [4, 2], [4, 3], [3, 4], [4, 4]]],
          [[4, 2], [[1, 0], [4, 0], [3, 2], [4, 3], [3, 4]]],
          [[4, 3], [[0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [3, 4], [4, 4]]],
          [
            [3, 4],
            [[4, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [4, 3], [4, 4]]
          ],
          [[4, 4], [[1, 0], [0, 2], [1, 2], [2, 2], [3, 2], [4, 3], [3, 4]]]
        )
      end
    end

    context 'with example input 2' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_2.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(40).items }
      its(:monitoring_station) { is_expected.to eq [5, 8] }
      its(:visible_from_monitoring_station) { is_expected.to have(33).items }
    end

    context 'with example input 3' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_3.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(40).items }
      its(:monitoring_station) { is_expected.to eq [1, 2] }
      its(:visible_from_monitoring_station) { is_expected.to have(35).items }
    end

    context 'with example input 4' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_4.txt') }
      its(:rows) { is_expected.to eq 10 }
      its(:columns) { is_expected.to eq 10 }
      its(:asteroids) { is_expected.to have(50).items }
      its(:monitoring_station) { is_expected.to eq [6, 3] }
      its(:visible_from_monitoring_station) { is_expected.to have(41).items }
    end

    context 'with example input 5' do
      let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_5.txt') }
      its(:rows) { is_expected.to eq 20 }
      its(:columns) { is_expected.to eq 20 }
      its(:asteroids) { is_expected.to have(300).items }
      its(:monitoring_station) { is_expected.to eq [11, 13] }
      its(:visible_from_monitoring_station) { is_expected.to have(210).items }
    end

    context 'with puzzle input' do
      let(:input_txt) { File.join(ROOT, '10', 'input.txt') }
      its(:rows) { is_expected.to eq 48 }
      its(:columns) { is_expected.to eq 48 }
      its(:asteroids) { is_expected.to have(346).items }
      its(:monitoring_station) { is_expected.to eq [37, 25] }
      its(:visible_from_monitoring_station) { is_expected.to have(309).items }
    end
  end
end
