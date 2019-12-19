#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require 'logger'

require_relative 'gravity_simulator'

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

simulator = GravitySimulator.from_txt(ARGV.first, logger: logger)

10.times do |index|
  puts "After #{index} times:"
  puts simulator.bodies
  simulator.step
end

# memory = File.open(ARGV.first) do |file|
#   file.each_line(',').map { |value| Integer(value.chomp(',')) }
# end
