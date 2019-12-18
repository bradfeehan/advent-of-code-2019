# frozen_string_literal: true

require_relative 'base'

module AsteroidFinder
  # Finds asteroids by working out if "blocker" of each other asteroid exists
  #
  # More efficient as it only checks the space between the candidate and each
  # asteroid for a potential blocker.
  class BlockerStrategy < Base
    def asteroids_with_visible
      @asteroids_with_visible ||= asteroids.map do |candidate|
        visible = (asteroids - [candidate]).reject do |viewed|
          offset = offset(from: candidate, to: viewed)
          iterations = iterations_required(offset, from: candidate, to: viewed)

          blockables = iterations.times.map do |index|
            add_offset(offset, to: candidate, count: index + 1)
          end

          blockables.any? { |pos| get(pos) == '#' }
        end

        [candidate, visible]
      end
    end

    private

    def iterations_required(offset, from:, to:)
      vertical = to[1] - from[1]
      horizontal = to[0] - from[0]

      if horizontal.zero?
        vertical / offset[1] - 1
      else
        horizontal / offset[0] - 1
      end
    end
  end
end
