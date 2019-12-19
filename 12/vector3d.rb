# frozen_string_literal: true

# Represents a 3-dimensional vector
class Vector3D
  DIMENSIONS = %i[x y z].freeze

  attr_accessor(*DIMENSIONS)

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def [](dimension)
    public_send(dimension)
  end

  def []=(dimension, value)
    public_send("#{dimension}=", value)
  end

  def ==(other)
    raise TypeError, "#{other} / #{self}" unless other.class == self.class

    DIMENSIONS.all? { |dimension| self[dimension] == other[dimension] }
  end
  alias eql? ==

  def inspect
    "#<#{self.class} x=#{x} y=#{y} z=#{z}>"
  end

  def to_s
    "<x=#{x}, y=#{y}, z=#{z}>"
  end
end
