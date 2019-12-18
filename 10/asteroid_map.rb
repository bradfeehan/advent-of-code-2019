# frozen_string_literal: true

require 'forwardable'
require 'set'

require_relative 'asteroid_finder/shadow_strategy'
require_relative 'asteroid_finder/blocker_strategy'
require_relative 'asteroid_laser'

# Represents a map of asteroids
class AsteroidMap
  extend Forwardable

  FINDER_METHODS = %i[
    asteroids_with_visible
    monitoring_station
    monitoring_station_with_visible
    visible_from_monitoring_station
  ].freeze

  delegate FINDER_METHODS => :asteroid_finder
  delegate %i[asteroids_by_angle laser_order] => :asteroid_laser

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
    raise ArgumentError, [column, row].to_s unless within_bounds? [column, row]
    raise ArgumentError, "No such row #{row}" if row >= rows
    raise ArgumentError, "No such column: #{column}" if column >= columns

    lines[row][column]
  end

  def get(pos)
    self[pos[0], pos[1]]
  end

  def asteroids
    @asteroids ||= lines.each_with_index.flat_map do |line, row|
      line
        .each_with_index
        .select { |cell, _column| cell == '#' }
        .map { |_cell, column| [column, row] }
    end
  end

  def within_bounds?(coordinate)
    return false if coordinate.any?(&:negative?)

    coordinate[0] < columns && coordinate[1] < rows
  end

  private

  def asteroid_finder
    @asteroid_finder ||= strategy_class.new(self)
  end

  def asteroid_laser
    @asteroid_laser ||= AsteroidLaser.new(self)
  end

  def strategy_class
    @strategy_class ||= AsteroidFinder.const_get("#{@strategy}Strategy")
  end
end
