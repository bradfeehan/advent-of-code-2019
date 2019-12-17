# frozen_string_literal: true

require File.join(ROOT, '8', 'image')

RSpec.describe SpaceImage do
  subject(:image) { described_class.new(input, height: height, width: width) }

  context 'with example input 1' do
    let(:height) { 2 }
    let(:width) { 3 }
    let(:input) { '123456789012' }
    its(:checksum) { is_expected.to eq 1 }
  end

  context 'with example input 2' do
    let(:height) { 2 }
    let(:width) { 2 }
    let(:input) { '0222112222120000' }
    its(:decode) { is_expected.to eq "##  \n  ##" }
  end

  context 'with puzzle input' do
    let(:height) { 6 }
    let(:width) { 25 }
    let(:input) { File.read(File.join(ROOT, '8', 'input.txt')).chomp }
    its(:checksum) { is_expected.to eq 2500 }
    describe '#decode' do
      subject(:decode) { image.decode }

      it 'has six rows' do
        expect(decode.split("\n").count).to eq 6
      end

      it 'has 25 columns' do
        expect(decode.split("\n")).to all(have(50).items)
      end

      it 'matches the expected output' do
        expect(decode).to eq [
          '##    ####  ######    ####  ####    ####  ####  ##',
          '  ####  ##  ######    ####  ##  ####  ##  ####  ##',
          '  ##########  ##  ##  ####  ##  ####  ##        ##',
          '  ############  ####  ####  ##        ##  ####  ##',
          '  ####  ######  ####  ####  ##  ####  ##  ####  ##',
          '##    ########  ######    ####  ####  ##  ####  ##'
        ].join("\n")
      end
    end

    describe 'input' do
      subject { input }
      its(:length) { is_expected.to eq 100 * 25 * 6 }
    end

    describe '#layers' do
      subject(:layers) { image.layers }
      its(:count) { is_expected.to eq 100 }
    end
  end
end
