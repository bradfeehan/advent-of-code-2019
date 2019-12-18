#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

require_relative 'asteroid_map'

map = AsteroidMap.new(ARGV.first)

puts "Best monitoring station: #{map.monitoring_station}"
count = map.visible_from_monitoring_station.count
puts "Visible asteroids (#{count}): #{map.visible_from_monitoring_station}"
