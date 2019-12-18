# frozen_string_literal: true

require_relative 'base'

module AsteroidFinder
  # Finds asteroids by working out where the "shadow" of each other asteroid is
  #
  # Fairly inefficient as it ends up calculating a lot of coordinates where the
  # shadow falls even though there might be no asteroid there.
  class ShadowStrategy < Base
    delegate %i[within_bounds?] => :@map

    def asteroids_with_visible
      @asteroids_with_visible ||= asteroids.map do |candidate|
        others = asteroids - [candidate]
        visible = Set.new(others)

        others.each do |blocker|
          next unless visible.include?(blocker)

          offset = offset(from: candidate, to: blocker)
          blocked =
            iterations_required(blocker, offset)
            .times
            .map { |index| add_offset(offset, to: blocker, count: index + 1) }
            .select { |pos| within_bounds?(pos) && get(pos) == '#' }

          visible.subtract(blocked)
        end

        [candidate, visible.to_a]
      end
    end

    private

    def iterations_required(blocker, offset)
      vertical_space = space_for(offset[1], rows, blocker[1])
      horizontal_space = space_for(offset[0], columns, blocker[0])
      [horizontal_space.to_f / offset[0], vertical_space.to_f / offset[1]]
        .reject(&:nan?)
        .min_by(&:abs)
        .floor
        .abs
    end

    def space_for(offset, total, start)
      offset.positive? ? total - start : start
    end
  end
end
