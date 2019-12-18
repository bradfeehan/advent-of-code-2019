# frozen_string_literal: true

require 'forwardable'
require 'set'

require_relative 'asteroid_finder/shadow_strategy'

# Represents a map of asteroids
class AsteroidMap
  extend Forwardable

  FINDER_METHODS = %i[
    asteroids
    asteroids_with_visible
    monitoring_station
    visible_from_monitoring_station
  ]

  delegate FINDER_METHODS => :asteroid_finder

  attr_reader :rows, :columns, :lines

  def initialize(input_file, strategy: :shadow)
    @lines = File.open(input_file) do |file|
      file.each_line(chomp: true).map { |line| line.each_char.to_a }
    end

    cols = lines.map(&:count)
    raise ArgumentError, "Column mismatch: #{cols}" unless cols.uniq.count == 1

    @rows = lines.count
    @columns = cols.first

    @strategy = strategy.capitalize
  end

  def [](column, row)
    raise ArgumentError, [column, row].to_s unless within_bounds? column, row
    raise ArgumentError, "No such row #{row}" if row >= rows
    raise ArgumentError, "No such column: #{column}" if column >= columns

    lines[row][column]
  end

  private

  def asteroid_finder
    @asteroid_finder ||= strategy_class.new(self)
  end

  def strategy_class
    @strategy_class ||= AsteroidFinder.const_get("#{@strategy}Strategy")
  end
end
