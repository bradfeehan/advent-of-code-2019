#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

input_file = ARGV.first
planets = {}

require_relative 'planet'

File.open(input_file) do |file|
  file.each_line(chomp: true).map do |line|
    planet_name, satellite_name = line.split(')', 2).map(&:to_sym)
    planet = (planets[satellite_name] ||= Planet.new(satellite_name))
    planet.orbits = (planets[planet_name] ||= Planet.new(planet_name))
  end
end

orbit_count = 0
you_chain = []
san_chain = []

planets.values.each do |planet|
  current = planet
  while current.orbits
    orbit_count += 1
    you_chain << current.orbits.name if planet.name == :YOU
    san_chain << current.orbits.name if planet.name == :SAN
    current = current.orbits
  end
end

puts "Total orbits: #{orbit_count}"

puts "You orbit #{you_chain.count}: #{you_chain}"
puts "San orbits #{san_chain.count}: #{san_chain}"


common_orbits = you_chain & san_chain
puts "Both orbit #{common_orbits.count}: #{common_orbits}"

path_to_common_ancestor = (you_chain.drop(1) - common_orbits.drop(1))
path_from_common_ancestor_to_san = (san_chain - common_orbits).reverse

transit_path = path_to_common_ancestor + path_from_common_ancestor_to_san
puts "Transit #{transit_path.count}; path: #{transit_path}"
