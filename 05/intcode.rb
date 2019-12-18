#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require_relative 'computer'

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end

computer = Intcode5::Computer.new(memory, logger: logger)

computer.run
