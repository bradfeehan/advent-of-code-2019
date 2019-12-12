# frozen_string_literal: true

require_relative 'edge'

# Represents a point on a two-dimensional grid
class Point
  attr_reader :x, :y

  def initialize(x:, y:) # rubocop:disable Naming/MethodParameterName
    @x = x
    @y = y
  end

  def manhattan
    x.abs + y.abs
  end

  def +(other)
    case other
    when Step then plus_step(other)
    else raise ArgumentError, "Can't add #{self.class} and #{other.class}"
    end
  end

  def to(other)
    case other
    when Point then to_point(other)
    else raise ArgumentError, "Can't go from #{self.class} to #{other.class}"
    end
  end

  def origin?
    x.zero? && y.zero?
  end

  def inspect
    "#<#{self.class} #{self}>"
  end

  def to_s
    "(#{x}, #{y})"
  end

  private

  def plus_step(step)
    distance = step.distance
    case step.direction
    when :L then Point.new(x: x - distance, y: y)
    when :R then Point.new(x: x + distance, y: y)
    when :U then Point.new(x: x, y: y + distance)
    when :D then Point.new(x: x, y: y - distance)
    end
  end

  def to_point(other)
    Edge.new(from: self, to: other)
  end
end
