# frozen_string_literal: true

module Intcode2
  # Represents a type of operation
  class Operation
    OPCODE_LENGTH = 1

    attr_reader :mnemonic, :opcode, :parameters

    def initialize(opcode, mnemonic, &block)
      @mnemonic = mnemonic
      @opcode = opcode
      @parameters = block.nil? ? 0 : block.arity
      @block = block
    end

    def execute(parameters, computer)
      computer.instance_exec(*parameters, &@block)
    end

    def length
      OPCODE_LENGTH + parameters
    end

    def to_s
      "#<#{self.class} opcode=#{opcode} length=#{length}>"
    end
  end
end
