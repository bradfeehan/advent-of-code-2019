#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

input_file = ARGV.first

def fuel_for(mass)
  return 0 if mass <= 0

  fuel = (mass / 3).floor - 2
  fuel_for_fuel = [0, fuel_for(fuel)].max
  fuel + fuel_for_fuel
end

fuel = File.open input_file do |file|
  file.each_line.reduce(0) do |sum, line|
    mass = Integer(line)
    sum + fuel_for(mass)
  end
end

puts "Fuel required for modules: #{fuel}"
