# frozen_string_literal: true

require_relative 'computer'

module Intcode
  # Represents a single amplifier in the chain
  class Amplifier
    def initialize(memory:, phase:)
      @memory = memory.dup
      @phase = phase
    end

    def call(input)
      computer(input).run
      stdout.string.chomp
    end

    private

    def computer(input)
      Computer.new(@memory.dup, stdout: stdout, stdin: stdin(input))
    end

    def stdout
      @stdout ||= StringIO.new
    end

    def stdin(input)
      StringIO.new([@phase, input].map { |line| line.to_s + "\n" }.join)
    end
  end
end
