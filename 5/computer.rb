# frozen_string_literal: true

require_relative 'instruction'

module Intcode
  # Represents an Intcode CPU initialized with a given memory contents
  class Computer
    attr_reader :memory
    alias m memory

    def initialize(memory)
      @memory = memory
      @instruction_pointer = 0
    end

    def run
      catch(:break) do
        loop do
          instruction = decode(fetch_instruction_data)
          @instruction_pointer += instruction.length

          warn memory.inspect
          warn instruction
          instruction.execute(self)
        end
      end
      warn memory.inspect
    end

    private

    def decode(data)
      opcode = data.first
      operation = INSTRUCTION_SET[opcode]
      parameters = data.slice(Operation::OPCODE_LENGTH, operation.parameters)
      Instruction.new(operation, parameters)
    end

    def fetch_instruction_data
      memory.slice(@instruction_pointer, Instruction::MAX_LENGTH)
    end
  end
end
