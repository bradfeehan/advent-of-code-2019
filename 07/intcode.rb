#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require_relative 'amplifier_chain'

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end

memory.freeze

ranges = [(0..4), (5..9)]

ranges.each do |range|
  results = range.to_a.permutation.map do |phases|
    amplifiers = Intcode7::AmplifierChain.new(
      memory: memory,
      phases: phases,
      logger: logger
    )
    [amplifiers.call(0), phases]
  end

  max_thrust, max_phases = results.max_by { |output, _| output }

  puts "Max thrust #{max_thrust} (phases #{max_phases})"
end
