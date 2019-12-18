#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'logger'

require_relative 'point'
require_relative 'step'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

wires = File.open(ARGV.first) do |file|
  file.each_line.map(&:chomp).map do |line|
    line.each_line(',').reduce([Point.new(x: 0, y: 0)]) do |points, step|
      step = Step.of(step.chomp(','))
      points + [points.last + step]
    end
  end
end

a_wire, b_wire = wires

crossing = []

a_path = []
a_wire.each_cons(2) do |a1, a2|
  path_to_a1 = a_path.dup
  a_edge = a1.to(a2)
  a_path << a_edge.distance

  b_path = []
  b_wire.each_cons(2) do |b1, b2|
    path_to_b1 = b_path.dup
    b_edge = b1.to(b2)
    b_path << b_edge.distance

    intersection = a_edge.intersection(b_edge)
    next if intersection.nil? || intersection.origin?

    logger.debug { "Found intersection #{a_edge}, #{b_edge}" }

    a_edge_to_intersection = a1.to(intersection)
    b_edge_to_intersection = b1.to(intersection)

    path_to_a1 << a_edge_to_intersection.distance
    path_to_b1 << b_edge_to_intersection.distance

    crossing << [a_edge, b_edge, path_to_a1, path_to_b1, intersection]
  end
end

results = crossing.map do |a, b, a_steps, b_steps, intersection|
  a_dist = a_steps.sum
  b_dist = b_steps.sum
  [
    "#{a} X #{b} @ #{intersection} = #{intersection.manhattan}",
    "after #{a_dist} + #{b_dist} = #{a_dist + b_dist}"
  ].join('; ')
end

logger.debug { results }

closest = crossing.map(&:last).min_by(&:manhattan)
puts "Closest to origin: #{closest}, Manhattan distance: #{closest.manhattan}"

shortest = crossing.min_by do |_, _, a_steps, b_steps, _|
  a_steps.sum + b_steps.sum
end

a_steps = shortest[2]
a_dist = a_steps.sum
b_steps = shortest[3]
b_dist = b_steps.sum

puts [
  "Shortest combined travel: #{shortest.last}",
  "travel: #{a_steps} = #{a_dist} && #{b_steps} = #{b_dist}",
  "total: #{a_dist + b_dist}"
].join('; ')
