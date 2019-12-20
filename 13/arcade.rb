# frozen_string_literal: true

require 'forwardable'
require 'logger'

require_relative '../09/computer'
require_relative 'curses_canvas'

# The ship's arcade cabinet
class Arcade
  extend Forwardable

  attr_reader :window

  def initialize(memory, window:, logger: Logger.new($stderr, level: :info))
    @memory = memory
    @window = window
    @logger = logger
  end

  def run
    Curses.init_screen
    Curses.curs_set(0) # Hide cursor
    computer.run
    window.setpos(window.maxy / 2, window.maxx / 2)
    window << '  GAME OVER  '
    window.refresh
    sleep 10
  ensure
    window.close
    Curses.close_screen
  end

  def canvas
    @canvas ||= CursesCanvas.new(@window, offset: [2, 0])
  end

  private

  def computer
    @computer ||= Intcode9::Computer.new(
      @memory,
      stdin: Stdin.new(self),
      stdout: Stdout.new(self),
      logger: @logger
    )
  end

  # Represents the stdin stream of the computer
  class Stdin
    def initialize(arcade)
      @arcade = arcade
      @arcade.window.keypad = true
      # @arcade.window.timeout = 1_000
    end

    def gets
      @arcade.canvas.position_of(Stdout::TILES[4])[1] <=> @arcade.canvas.position_of(Stdout::TILES[3])[1]
      # case
      # when 1
      # char = @arcade.window.getch
      # case char
      # when Curses::Key::RIGHT then "1\n"
      # when Curses::Key::LEFT then "-1\n"
      # else "0\n"
      # end
    end
  end

  # Represents the stdout stream of the computer
  class Stdout
    TILES = {
      0 => ' ',
      1 => '#',
      2 => '=',
      3 => '_',
      4 => 'o'
    }.freeze

    def initialize(arcade)
      @arcade = arcade
      @buffer = []
    end

    def puts(string)
      @buffer.push(string)
      paint if @buffer.size == 3
    end

    private

    def paint
      x, y, tile_id = @buffer
      @arcade.canvas[[y, x]] = TILES.fetch(tile_id, tile_id)
      @buffer.clear
    end
  end
end
