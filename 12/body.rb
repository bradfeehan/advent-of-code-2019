# frozen_string_literal: true

require_relative 'vector3d'

# Represents a body with position and velocity in 3D space
class Body
  attr_accessor :position, :velocity

  def initialize(position, velocity = Vector3D.new(0, 0, 0))
    @position = position
    @velocity = velocity
  end

  def x
    [position.x, velocity.x]
  end

  def y
    [position.y, velocity.y]
  end

  def z
    [position.z, velocity.z]
  end

  def apply_gravity(other, dimensions:)
    dimensions.each do |dimension|
      case position[dimension] <=> other.position[dimension]
      when -1
        velocity[dimension] += 1
        other.velocity[dimension] -= 1
      when 1
        velocity[dimension] -= 1
        other.velocity[dimension] += 1
      end
    end
  end

  def apply_velocity(dimensions:)
    dimensions.each { |dimension| position[dimension] += velocity[dimension] }
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  def potential_energy
    Vector3D::DIMENSIONS.sum { |dimension| position[dimension].abs }
  end

  def kinetic_energy
    Vector3D::DIMENSIONS.sum { |dimension| velocity[dimension].abs }
  end

  def dup
    self.class.new(position.dup, velocity.dup)
  end

  def ==(other)
    raise TypeError, "#{other} / #{self}" unless other.class == self.class

    position == other.position && velocity == other.velocity
  end
  alias eql? ==

  def to_s
    "pos=#{position}, vel=#{velocity}"
  end

  def inspect
    "#<#{self.class} #{self}>"
  end
end
