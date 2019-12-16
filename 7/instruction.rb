# frozen_string_literal: true

require_relative 'instruction_set'

module Intcode
  # Represents a single Intcode instruction
  class Instruction
    extend Forwardable

    MAX_LENGTH = INSTRUCTION_SET.values.map(&:length).max

    attr_reader :operation, :parameters
    delegate %i[length opcode] => :operation

    def initialize(operation, parameters, computer:)
      @operation = operation
      @parameters = parameters
      @computer = computer
    end

    def execute
      operation.execute(parameters, @computer)
    end

    def to_s
      operation.mnemonic % parameter_mnemonics
    end

    def inspect
      [
        "#<#{self.class}",
        "'#{self}'",
        "opcode=#{opcode}",
        "parameters=#{parameter_mnemonics.join(',')}>"
      ].join(' ')
    end

    private

    def parameter_mnemonics
      parameters.map(&:mnemonic)
    end
  end
end
