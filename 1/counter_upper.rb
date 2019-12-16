#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

input_file = ARGV.first

def fuel_for(mass, including_fuel: false)
  return 0 if mass <= 0

  fuel = (mass / 3).floor - 2
  return fuel unless including_fuel

  fuel_for_fuel = [0, fuel_for(fuel, including_fuel: including_fuel)].max
  fuel + fuel_for_fuel
end

modules_fuel = 0
total_fuel = 0

File.open input_file do |file|
  file.each_line do |line|
    mass = Integer(line)
    modules_fuel += fuel_for(mass)
    total_fuel += fuel_for(mass, including_fuel: true)
  end
end

puts "Fuel required for modules: #{modules_fuel}"
puts "Total fuel required: #{total_fuel}"
