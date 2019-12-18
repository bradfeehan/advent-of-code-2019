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

map = AsteroidMap.new(ARGV.first, strategy: :blocker)

station, visible = map.monitoring_station_with_visible

puts "Best monitoring station: #{station}"
puts "Visible asteroids (#{visible.count}): #{visible}"
