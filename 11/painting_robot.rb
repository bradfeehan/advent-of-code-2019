# frozen_string_literal: true

require 'logger'

require_relative 'canvas'
require_relative '../9/computer'

# Represents the Emergency Hull Painting Robot
class PaintingRobot
  COMPASS = %i[north east south west].freeze

  attr_reader :position, :facing

  def initialize(initial_memory, logger: Logger.new($stderr, level: :info))
    @initial_memory = initial_memory
    @logger = logger
    @position = [0, 0]
    @facing = :north
  end

  def canvas
    @canvas ||= Canvas.new
  end

  def paint(value)
    canvas[position] = value
  end

  def turn(direction)
    case direction
    when :left then @facing = COMPASS.rotate(-1)[compass_index]
    when :right then @facing = COMPASS.rotate(1)[compass_index]
    else raise ArgumentError, "Unknown turn direction #{direction}"
    end

    move
  end

  def run
    computer.run
  end

  private

  def move
    case facing
    when :north then position[0] -= 1
    when :south then position[0] += 1
    when :east then position[1] += 1
    when :west then position[1] -= 1
    else raise ArgumentError, "Unknown facing direction #{facing}"
    end
  end

  def computer
    @computer ||= Intcode9::Computer.new(
      @initial_memory,
      stdin: Stdin.new(self),
      stdout: Stdout.new(self),
      logger: @logger
    )
  end

  def compass_index
    COMPASS.find_index(facing)
  end

  # Represents the stdin connection between the robot and computer
  class Stdin
    def initialize(robot)
      @robot = robot
    end

    def gets
      (current_cell == '#' ? '1' : '0') + "\n"
    end

    private

    def current_cell
      @robot.canvas[@robot.position]
    end
  end

  # Represents the stdout connection between robot and computer
  class Stdout
    def initialize(robot)
      @robot = robot
      @move = false
    end

    def puts(string)
      @move ? move(string) : paint(string)
    end

    private

    def move(string)
      case string
      when 0 then @robot.turn(:left)
      when 1 then @robot.turn(:right)
      else raise ArgumentError, "Unknown movement direction #{string}"
      end
      @move = false
    end

    def paint(string)
      case string
      when 0 then @robot.paint(',')
      when 1 then @robot.paint('#')
      else raise ArgumentError, "Unknown paint colour '#{string.inspect}'"
      end
      @move = true
    end
  end
end
