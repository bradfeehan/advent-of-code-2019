# frozen_string_literal: true

require_relative 'computer'

module Intcode7
  # Represents a single amplifier in the chain
  class Amplifier
    attr_reader :name, :stdin, :stdout

    def initialize(name, memory:, stdin:, stdout:)
      @name = name
      @memory = memory.dup
      @stdin = stdin
      @stdout = stdout
    end

    def call
      computer.run
    end

    private

    def computer
      Computer.new(name, @memory.dup, stdout: @stdout, stdin: @stdin)
    end
  end
end
