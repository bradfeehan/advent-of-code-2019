#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

input_text = File.read(ARGV.first)
lower, upper = input_text.split('-')
range = Integer(lower)..Integer(upper)

# puts range

candidates = range.each.select do |value|
  d = value.to_s.each_char
  d.sort == d.to_a && d.each_cons(2).any? { |a, b| a == b }
end

puts "Part 1: #{candidates.count} candidates"

candidates.select! do |value|
  s = value.to_s
  s.gsub!(/(1{3,}|2{3,}|3{3,}|4{3,}|5{3,}|6{3,}|7{3,}|8{3,}|9{3,})/, '')
  d = s.to_s.each_char
  d.each_cons(2).any? { |a, b| a == b }
end

puts "Part 2: #{candidates.count} candidates"
