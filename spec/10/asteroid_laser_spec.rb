# frozen_string_literal: true

require File.join(ROOT, '10', 'asteroid_map')

RSpec.describe AsteroidLaser do
  subject(:map) { AsteroidMap.new(input_txt) }
  let(:asteroids) { [] }

  context 'with example input 6' do
    let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_6.txt') }

    its(:monitoring_station) { is_expected.to eq [8, 3] }
    its(:visible_from_monitoring_station) { is_expected.to have(30).items }
    its(:laser_order) do
      is_expected.to eq [
        [8, 1], [9, 0], [9, 1], [10, 0], [9, 2], [11, 1], [12, 1], [11, 2],
        [15, 1], [12, 2], [13, 2], [14, 2], [15, 2], [12, 3], [16, 4],
        [15, 4], [10, 4], [4, 4], [2, 4], [2, 3], [0, 2], [1, 2], [0, 1],
        [1, 1], [5, 2], [1, 0], [5, 1], [6, 1], [6, 0], [7, 0], [8, 0],
        [10, 1], [14, 0], [16, 1], [13, 3], [14, 3]
      ]
    end
  end

  context 'with example input 5' do
    let(:input_txt) { File.join(ROOT, 'spec', '10', 'example_5.txt') }

    describe '#laser_order' do
      subject(:laser_order) { map.laser_order }
      it('has [11, 12] 1st') { expect(laser_order[0]).to eq [11, 12] }
      it('has [12, 1] 2nd') { expect(laser_order[1]).to eq [12, 1] }
      it('has [12, 2] 3rd') { expect(laser_order[2]).to eq [12, 2] }
      it('has [12, 8] 10th') { expect(laser_order[9]).to eq [12, 8] }
      it('has [16, 0] 20th') { expect(laser_order[19]).to eq [16, 0] }
      it('has [16, 9] 50th') { expect(laser_order[49]).to eq [16, 9] }
      it('has [10, 16] 100th') { expect(laser_order[99]).to eq [10, 16] }
      it('has [9, 6] 199th') { expect(laser_order[198]).to eq [9, 6] }
      it('has [8, 2] 200th') { expect(laser_order[199]).to eq [8, 2] }
      it('has [10, 9] 201st') { expect(laser_order[200]).to eq [10, 9] }
      it('has [11, 1] 299th') { expect(laser_order[298]).to eq [11, 1] }
    end
  end
end
