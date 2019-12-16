# frozen_string_literal: true

require_relative 'amplifier'

module Intcode
  # Represents a chain of amplifiers
  class AmplifierChain
    def initialize(memory:, phases:)
      @amps = phases.map { |phase| Amplifier.new(memory: memory, phase: phase) }
    end

    def call(input)
      value = input

      @amps.each do |amplifier|
        value = amplifier.call(value)
      end

      value
    end
  end
end
