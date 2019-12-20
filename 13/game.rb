#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require 'curses'

require_relative 'arcade'

logger_level = ARGV.delete('-v').nil? ? :info : :debug

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end

logger = Logger.new($stderr, level: logger_level)
memory[0] = 2
arcade = Arcade.new(memory, window: Curses.stdscr, logger: logger)
arcade.run
