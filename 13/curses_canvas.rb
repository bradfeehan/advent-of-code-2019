# frozen_string_literal: true

# A canvas which writes to a curses window
class CursesCanvas
  def initialize(window, offset: [0, 1])
    @window = window
    @offset = offset
    @debug_line = 0
    @positions = Arcade::Stdout::TILES.map { |k, v| [k, [0, 0]] }.to_h
  end

  def []=(position, value)
    if position.any?(&:negative?)
      self.score = value
      debug value
    else
      y, x = position
      @window.setpos(y + @offset[0], x + @offset[1])
      @window << value
      update_position(position, value)
    end
    # @window.refresh
  end

  def score=(value)
    @window.setpos(0, 1)
    @window << "SCORE: #{value}   "
  end

  def position_of(value)
    @positions[value]
  end

  def debug(message)
    @window.setpos(@debug_line, 40)
    @window << "Debug: #{message}"
    # @window.refresh
    @debug_line = (@debug_line + 1) % @window.maxy
  end

  private

  def update_position(position, value)
    @positions[value] = position
  end
end
