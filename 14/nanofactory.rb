#!/usr/bin/env ruby
#
# frozen_string_literal: true

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require 'logger'

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

require_relative 'recipe'

target = { FUEL: 1 }
recipe = NanoFactory::Recipe.load(ARGV.first, target: target, logger: logger)

target_string = target.map { |k, v| "#{v} #{k}"}.join(', ')
puts "Ore for target #{target_string}: #{recipe.ore_for_target}"

ore_count = 1_000_000_000_000
# target_count = recipe.target_count_for(ore_count: ore_count)
target_count = recipe.targets(from: NanoFactory::Inventory.new(ORE: ore_count))
puts "With #{ore_count} ore, can make #{target_count} times"
