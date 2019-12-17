# frozen_string_literal: true

require_relative 'computer'

module Intcode2
  # Represents a calculation done with an Intcode program
  class Calculator
    def initialize(input_file:)
      @input_file = input_file
    end

    def result(noun:, verb:)
      comp = computer(noun, verb)
      comp.run
      comp.memory[0]
    end

    private

    def computer(noun, verb)
      Computer.new(initial_memory.dup).tap do |computer|
        computer.memory[1] = noun
        computer.memory[2] = verb
      end
    end

    def initial_memory
      @initial_memory ||= File.open(@input_file) do |file|
        file.each_line(',').map { |value| Integer(value.chomp(',')) }
      end
    end
  end
end
