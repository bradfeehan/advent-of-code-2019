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

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end


logger = Logger.new($stderr, level: logger_level)
computer = Intcode9::Computer.new(memory, logger: logger)

computer.run
