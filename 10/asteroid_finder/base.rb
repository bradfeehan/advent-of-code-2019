# frozen_string_literal: true

require 'forwardable'

module AsteroidFinder
  # Base class for AsteroidFinder subclasses
  class Base
    extend Forwardable

    delegate %i[asteroids rows columns lines [] get] => :@map

    def initialize(map)
      @map = map
      raise NotImplementedError if self.class == Base
    end

    def monitoring_station_with_visible
      asteroids_with_visible.max_by { |_, v| v.count }
    end

    private

    def offset(from:, to:)
      simplify_offset([to[0] - from[0], to[1] - from[1]])
    end

    def simplify_offset(offset)
      columns, rows = offset

      return [(columns <=> 0), 0] if rows.zero?

      ratio = Rational(columns, rows)
      [
        ratio.numerator.abs * (columns <=> 0),
        ratio.denominator.abs * (rows <=> 0)
      ]
    end
  end
end
