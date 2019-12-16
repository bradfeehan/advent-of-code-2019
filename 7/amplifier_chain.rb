# frozen_string_literal: true

require_relative 'amplifier'

module Intcode
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
      @output = StringIO.new
    end

    def call(input)
      @input.puts(input)

      threads = []

      # Create tee
      threads << Thread.new do
        line = @end.gets
        @input.puts(line) unless @amps.first.stdin.closed?
        @output.puts(line)
      end

      threads += @amps.map { |amplifier| Thread.new { amplifier.call } }

      threads.each(&:join)

      @output.string.chomp
    end
  end
end
