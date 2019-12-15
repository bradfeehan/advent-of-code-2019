# frozen_string_literal: true

require_relative 'instruction_set'

module Intcode
  # Represents a single Intcode instruction
  class Instruction
    extend Forwardable

    MAX_LENGTH = INSTRUCTION_SET.values.map(&:length).max

    attr_reader :operation, :parameters
    delegate %i[length opcode] => :operation

    def initialize(operation, parameters)
      @operation = operation
      @parameters = parameters
    end

    def execute(computer)
      operation.execute(parameters, computer)
    end

    def mnemonic
      operation.mnemonic % parameters
    end

    def to_s
      [
        "#<#{self.class}",
        "'#{mnemonic}'",
        "opcode=#{opcode}",
        "parameters=#{parameters.join(',')}>"
      ].join(' ')
    end
  end
end
