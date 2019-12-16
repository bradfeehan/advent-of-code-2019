#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

require_relative 'amplifier_chain'

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end

memory.freeze

ranges = [(0..4), (5..9)]

ranges.each do |range|
  results = range.to_a.permutation.map do |phases|
    amplifiers = Intcode::AmplifierChain.new(memory: memory, phases: phases)
    [amplifiers.call(0), phases]
  end

  max_thrust, max_phases = results.max_by { |output, _| output }

  puts "Max thrust #{max_thrust} (phases #{max_phases})"
end
