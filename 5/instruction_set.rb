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
    1  => op(1, 'ADD %s,%s->%s') { |a, b, d| d.write(a + b) },
    2  => op(2, 'MUL %s,%s->%s') { |a, b, d| d.write(a * b) },
    3  => op(3, 'IN ->%s') { |a| a.write(Integer($stdin.gets)) },
    4  => op(4, 'OUT %s') { |a| $stdout.puts(a.read) },
    5  => op(5, 'JPT %s?->%s') { |c, d| self.ip = d.read if c != 0 },
    6  => op(6, 'JPF %s?->%s') { |c, d| self.ip = d.read if c.zero? },
    7  => op(7, 'LT %s<%s->%s') { |a, b, d| d.write(a < b ? 1 : 0) },
    8  => op(8, 'EQ %s=%s->%s') { |a, b, d| d.write(a == b ? 1 : 0) },
    99 => op(99, 'HALT') { throw(:break) }
  )
end
