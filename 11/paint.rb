#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require_relative 'painting_robot'

logger_level = ARGV.delete('-v').nil? ? :info : :debug

memory = File.open(ARGV.first) do |file|
  file.each_line(',').map { |value| Integer(value.chomp(',')) }
end

logger = Logger.new($stderr, level: logger_level)
robot = PaintingRobot.new(memory, logger: logger)
robot.run
puts 'Canvas: '
puts robot.canvas.to_s

puts "Painted #{robot.canvas.painted} cells"

robot = PaintingRobot.new(memory, logger: logger)
robot.paint('#')
robot.run
puts 'Canvas: '
puts robot.canvas.to_s
