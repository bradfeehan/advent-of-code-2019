# frozen_string_literal: true

require 'forwardable'

# Represents the laser which destroys asteroids
class AsteroidLaser
  extend Forwardable

  delegate %i[asteroids monitoring_station] => :@map

  def initialize(map)
    @map = map
    @monitoring_station = map.monitoring_station
  end

  def laser_order
    lists = asteroids_by_angle_and_distance.values
    result = []

    until lists.empty?
      result += lists.map(&:shift)
      lists.reject!(&:empty?)
    end

    result
  end

  private

  def asteroids_by_angle
    (asteroids - [monitoring_station]).group_by { |asteroid| angle(asteroid) }
  end

  def asteroids_by_angle_and_distance
    asteroids_by_angle
      .sort_by(&:first)
      .map { |angle, list| [angle, list.sort_by { |pos| distance(pos) }] }
      .to_h
  end

  def angle(to)
    angle = Math.atan2(
      to[1] - @monitoring_station[1],
      to[0] - @monitoring_station[0]
    )
    (angle - (3 * Math::PI / 2)) % (Math::PI * 2)
  end

  def distance(to)
    Math.sqrt(
      (to[0] - @monitoring_station[0])**2 +
      (to[1] - @monitoring_station[1])**2
    )
  end
end
