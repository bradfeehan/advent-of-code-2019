# frozen_string_literal: true

require 'forwardable'

module AsteroidFinder
  # Finds asteroids by working out where the "shadow" of each other asteroid is
  #
  # Fairly inefficient as it ends up calculating a lot of coordinates where the
  # shadow falls even though there might be no asteroid there.
  class ShadowStrategy
    extend Forwardable

    delegate %i[rows columns lines []] => :@map

    def initialize(map)
      @map = map
    end

    def monitoring_station
      monitoring_station_with_visible.first
    end

    def visible_from_monitoring_station
      monitoring_station_with_visible[1]
    end

    def monitoring_station_with_visible
      @monitoring_station_with_visible ||=
        asteroids_with_visible.max_by { |_, v| v.count }
    end

    def asteroids
      @asteroids ||= lines.each_with_index.flat_map do |line, row|
        line
          .each_with_index
          .select { |cell, _column| cell == '#' }
          .map { |_cell, column| [column, row] }
      end
    end

    def asteroids_with_visible
      @asteroids_with_visible ||= asteroids.map do |candidate|
        others = (asteroids - [candidate])
        visible = Set.new(others)

        others.each do |blocker|
          next unless visible.include?(blocker)

          offset = blocking_offset(candidate, blocker)
          iterations = iterations_required(blocker, offset)

          blocked = iterations.times.map(&:succ).map do |index|
            [blocker[0] + offset[0] * index, blocker[1] + offset[1] * index]
          end

          visible.subtract(blocked.select { |pos| within_bounds?(pos) })
        end

        [candidate, visible.to_a]
      end
    end

    private

    def within_bounds?(coordinate)
      return false if coordinate.any?(&:negative?)

      coordinate[0] < columns || coordinate[1] < rows
    end

    def blocking_offset(location, blocker)
      columns = blocker[0] - location[0]
      rows = blocker[1] - location[1]

      return [(columns <=> 0), 0] if rows.zero?

      ratio = Rational(columns, rows)
      [
        ratio.numerator.abs * (columns <=> 0),
        ratio.denominator.abs * (rows <=> 0)
      ]
    end

    def iterations_required(blocker, offset)
      vertical_space = offset[1].positive? ? rows - blocker[1] : blocker[1]
      horizontal_space = offset[0].positive? ? columns - blocker[0] : blocker[0]
      [horizontal_space.to_f / offset[0], vertical_space.to_f / offset[1]]
        .reject(&:nan?)
        .min_by(&:abs)
        .floor
        .abs
    end
  end
end
