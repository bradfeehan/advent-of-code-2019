# frozen_string_literal: true

require_relative 'base'

module AsteroidFinder
  # Finds asteroids by working out if "blocker" of each other asteroid exists
  #
  # More efficient as it only checks the space between the candidate and each
  # asteroid for a potential blocker.
  class BlockerStrategy < Base
    def asteroids_with_visible
      asteroids.map do |candidate|
        others = (asteroids - [candidate])
        visible = others.reject do |viewed|
          offset = offset(from: candidate, to: viewed)
          iterations = iterations_required(offset, from: candidate, to: viewed)
          iterations -= 1
          next if iterations.zero?

          blockables = iterations.times.map(&:succ).map do |index|
            [candidate[0] + offset[0] * index, candidate[1] + offset[1] * index]
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
        vertical / offset[1]
      else
        horizontal / offset[0]
      end
    end
  end
end
