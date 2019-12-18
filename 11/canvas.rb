# frozen_string_literal: true

# Represents the canvas that the PaintingRobot paints upon
class Canvas
  UNTOUCHED = '.'
  MIN_SIZE = 1

  def initialize
    @rows = Hash.new { {} }.merge(0 => {}, MIN_SIZE - 1 => {})
    @column_index_min = 0
    @column_index_max = MIN_SIZE - 1
  end

  def [](position)
    expand(position)
    row, column = position
    @rows[row].fetch(column, UNTOUCHED)
  end

  def []=(position, value)
    expand(position)
    row, column = position
    @rows[row][column] = value
  end

  def stdin(robot)
    Stdin.new(self, robot)
  end

  def stdout(robot)
    Stdout.new(self, robot)
  end

  def to_s
    column_indices = @column_index_min..@column_index_max
    lines = all_rows.map do |row|
      line = column_indices.map { |column| row.fetch(column, UNTOUCHED) }.join
      line
    end

    lines.join("\n")
  end

  def painted
    @rows.values.map { |row| row.keys.count }.sum
  end

  private

  def row_indices
    row_indices = @rows.keys
    row_indices.min..row_indices.max
  end

  def all_rows
    row_indices.map { |row_index| @rows[row_index] }
  end

  def expand(position)
    row, column = position

    @column_index_min = column if column < @column_index_min
    @column_index_max = column if column > @column_index_max

    @rows[row] = {} unless @rows.key?(row)
  end
end
