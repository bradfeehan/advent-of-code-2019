# frozen_string_literal: true

# Represents a step of a wire, e.g. left for 30
class Step
  PATTERN = /\A(?<direction>[UDLR])(?<distance>\d+)\z/.freeze

  def self.of(description)
    match_data = description.match(PATTERN)
    raise ArgumentError, "Unknown step #{description}" unless match_data

    direction = match_data[:direction].to_sym
    distance = Integer(match_data[:distance])
    new(direction: direction, distance: distance)
  end

  attr_reader :direction, :distance

  def initialize(direction:, distance:)
    @direction = direction
    @distance = distance
  end

  def description
    @description ||= direction.to_s + distance.to_s
  end

  def to_s
    "#<#{self.class} #{description}>"
  end
end
