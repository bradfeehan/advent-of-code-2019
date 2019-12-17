# frozen_string_literal: true

require_relative 'amplifier'

module Intcode7
  # Represents a chain of amplifiers
  class AmplifierChain
    def initialize(memory:, phases:)
      stdin, stdout = IO.pipe
      @input = stdout

      @amps = phases.each_with_index.map do |phase, index|
        stdout.puts(phase)
        next_stdin, stdout = IO.pipe
        amp = Amplifier.new(index, memory: memory, stdin: stdin, stdout: stdout)
        stdin = next_stdin
        amp
      end

      @end = stdin
    end

    def call(input)
      @input.puts(input)

      threads = []

      # Create tee
      threads << Thread.new do
        until (line = @end.gets).nil?
          @output = line.chomp
          @input.puts(line) unless @amps.first.stdin.closed?
        end
      end

      threads += @amps.map { |amplifier| Thread.new { amplifier.call } }

      threads.each(&:join)

      Integer(@output)
    end
  end
end
