# frozen_string_literal: true

require 'logger'

require_relative 'body'
require_relative 'vector3d'

# Represents a simulation of multiple-body gravity
class GravitySimulator
  attr_reader :bodies

  def self.from_txt(input_txt, logger: Logger.new($stderr, level: :info))
    positions = File.open(input_txt) do |file|
      file.each_line(chomp: true).map do |line|
        matches = line.match(/\A<x=(-?\d+), y=(-?\d+), z=(-?\d+)>\z/)
        Vector3D.new(*matches.captures.map { |coordinate| Integer(coordinate) })
      end
    end

    new(positions.map { |position| Body.new(position) }, logger: logger)
  end

  def initialize(bodies, logger: Logger.new($stderr, level: :info))
    @bodies = bodies
    @logger = logger
  end

  def total_period
    Vector3D::DIMENSIONS.map { |dimension| period(dimension) }.reduce(1, &:lcm)
  end

  def period(dimension)
    foo = dup
    count = 0

    loop do
      foo.send(:apply_gravity, dimensions: [dimension])
      foo.send(:apply_velocity, dimensions: [dimension])
      count += 1
      break if foo.bodies.map(&dimension) == bodies.map(&dimension)
    end

    count
  end

  def total_energy
    @bodies.sum(&:total_energy)
  end

  def step
    apply_gravity
    apply_velocity
  end

  def dup
    self.class.new(bodies.map(&:dup), logger: @logger)
  end

  private

  def apply_gravity(dimensions: Vector3D::DIMENSIONS)
    @bodies.combination(2).each do |a, b|
      a.apply_gravity(b, dimensions: dimensions)
    end
  end

  def apply_velocity(dimensions: Vector3D::DIMENSIONS)
    @bodies.each { |body| body.apply_velocity(dimensions: dimensions) }
  end
end
