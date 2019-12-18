# frozen_string_literal: true

# Represents an edge going from one point to another
class Edge
  attr_reader :from, :to

  def initialize(from:, to:)
    @from = from
    @to = to
  end

  def distance
    Integer(Math.sqrt((to.x - from.x)**2 + (to.y - from.y)**2))
  end

  def orientation
    return :H if from.x == to.x
    return :V if from.y == to.y
  end

  def intersection(other)
    case other
    when Edge then intersection_edge(other)
    else raise ArgumentError, "Can't intersect #{self.class} and #{other.class}"
    end
  end

  def inspect
    "#<#{self.class} #{self}>"
  end

  def to_s
    "#{from}->#{to}"
  end

  private

  def intersection_edge(other) # rubocop:disable Metrics/AbcSize
    d_x = to.x - from.x
    d_y = to.y - from.y

    determinant = d_x * (other.to.y - other.from.y) -
                  (other.to.x - other.from.x) * d_y

    return nil if determinant.zero?

    lamb = (
      (other.to.y - other.from.y) * (other.to.x - from.x) +
      (other.from.x - other.to.x) * (other.to.y - from.y)
    ) / determinant.to_f

    delt = (
      (from.y - to.y) * (other.to.x - from.x) +
      d_x * (other.to.y - from.y)
    ) / determinant.to_f

    return nil unless (0..1).include?(lamb) && (0..1).include?(delt)

    Point.new(x: Integer(from.x + lamb * d_x), y: Integer(from.y + lamb * d_y))
  end
end
