# frozen_string_literal: true

require File.join(ROOT, '5', 'computer')

RSpec.describe Intcode5::Computer do
  let(:computer) do
    described_class.new(
      initial_memory,
      stdout: stdout,
      stderr: stderr,
      stdin: stdin
    )
  end

  let(:stdout) { StringIO.new }
  let(:stderr) { StringIO.new }
  let(:stdin) { StringIO.new(input + "\n") }
  let(:input) { '' }

  before { computer.run }

  context 'with day 5 examples' do
    subject(:output) { stdout.string.chomp }

    context 'with example 1' do
      let(:initial_memory) { [3, 0, 4, 0, 99] }

      context 'with "123" on stdin' do
        let(:input) { '123' }
        it { is_expected.to eq '123' }
      end
    end

    context 'with example 2' do
      let(:initial_memory) { [1002, 4, 3, 4, 33] }
      subject(:output) { computer.memory }
      it { is_expected.to eq [1002, 4, 3, 4, 99] }
    end

    context 'with example 3' do
      let(:initial_memory) { [1101, 100, -1, 4, 0] }
      subject(:output) { computer.memory }
      it { is_expected.to eq [1101, 100, -1, 4, 99] }
    end

    context 'with example 4' do
      let(:initial_memory) { [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8] }

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '1' }
      end

      context 'with "90" on stdin' do
        let(:input) { '90' }
        it { is_expected.to eq '0' }
      end
    end

    context 'with example 5' do
      let(:initial_memory) { [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8] }

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '0' }
      end

      context 'with "2" on stdin' do
        let(:input) { '2' }
        it { is_expected.to eq '1' }
      end
    end

    context 'with example 6' do
      let(:initial_memory) { [3, 3, 1108, -1, 8, 3, 4, 3, 99] }

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '1' }
      end

      context 'with "90" on stdin' do
        let(:input) { '90' }
        it { is_expected.to eq '0' }
      end
    end

    context 'with example 7' do
      let(:initial_memory) { [3, 3, 1107, -1, 8, 3, 4, 3, 99] }

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '0' }
      end

      context 'with "2" on stdin' do
        let(:input) { '2' }
        it { is_expected.to eq '1' }
      end
    end

    context 'with example 8' do
      let(:initial_memory) do
        [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
      end

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '1' }
      end

      context 'with "0" on stdin' do
        let(:input) { '0' }
        it { is_expected.to eq '0' }
      end
    end

    context 'with example 9' do
      let(:initial_memory) { [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1] }

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '1' }
      end

      context 'with "0" on stdin' do
        let(:input) { '0' }
        it { is_expected.to eq '0' }
      end
    end

    context 'with example 10' do
      let(:initial_memory) do
        [
          3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31,
          1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104,
          999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99
        ]
      end

      context 'with "3" on stdin' do
        let(:input) { '3' }
        it { is_expected.to eq '999' }
      end

      context 'with "8" on stdin' do
        let(:input) { '8' }
        it { is_expected.to eq '1000' }
      end

      context 'with "90" on stdin' do
        let(:input) { '90' }
        it { is_expected.to eq '1001' }
      end
    end
  end

  context 'with day 2 examples' do
    subject(:output) { computer.memory }

    context 'with example 1' do
      let(:initial_memory) { [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50] }
      it { is_expected.to eq [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50] }
    end

    context 'with example 2' do
      let(:initial_memory) { [1, 0, 0, 0, 99] }
      it { is_expected.to eq [2, 0, 0, 0, 99] }
    end

    context 'with example 3' do
      let(:initial_memory) { [2, 3, 0, 3, 99] }
      it { is_expected.to eq [2, 3, 0, 6, 99] }
    end

    context 'with example 4' do
      let(:initial_memory) { [2, 4, 4, 5, 99, 0] }
      it { is_expected.to eq [2, 4, 4, 5, 99, 9801] }
    end

    context 'with example 5' do
      let(:initial_memory) { [1, 1, 1, 4, 99, 5, 6, 0, 99] }
      it { is_expected.to eq [30, 1, 1, 4, 2, 5, 6, 0, 99] }
    end
  end
end
