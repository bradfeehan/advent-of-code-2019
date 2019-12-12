# frozen_string_literal: true

require_relative 'operation'

module Intcode # rubocop:disable Style/Documentation
  class << self
    private

    # Creates a new Operation
    def op(*args, &block)
      Operation.new(*args, &block)
    end
  end

  # Represents a set of Instructions for an Intcode computer
  class InstructionSet
    extend Forwardable

    delegate %i[values] => :@set

    def initialize(set)
      @set = set.freeze
    end

    def [](opcode)
      @set[opcode].tap { |op| raise UnknownOpcodeError, opcode unless op }
    end

    # Raised for unknown operations
    class UnknownOpcodeError < RuntimeError
      def initialize(opcode)
        super("Unknown opcode #{opcode}")
      end
    end
  end

  INSTRUCTION_SET = InstructionSet.new(
    1  => op(1, 'ADD (%s),(%s)->%s') { |a, b, d| m[d] = m[a] + m[b] },
    2  => op(2, 'MUL (%s),(%s)->%s') { |a, b, d| m[d] = m[a] * m[b] },
    99 => op(99, 'HALT') { throw(:break) }
  )
end
