# frozen_string_literal: true

# Represents a planet
class Planet
  attr_reader :name
  attr_accessor :orbits

  def initialize(name)
    @name = name
  end
end
