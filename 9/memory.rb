# frozen_string_literal: true

require 'forwardable'

module Intcode9
  # Represents an Intcode memory with default value
  class Memory
    DEFAULT_VALUE = 0

    extend Forwardable

    attr_reader :data
    delegate %i[values [] []=] => :data
    delegate %i[to_s inspect] => :values

    def initialize(data)
      @data = (0...data.count).zip(data).to_h.tap do |hash|
        hash.default = DEFAULT_VALUE
      end
    end

    def slice(start, count)
      (start...(start + count)).map { |index| self[index] }
    end

    def ==(other)
      case other
      when Array then data.values == other
      when Hash then data == other
      when Memory then other.data = data
      else raise TypeError, "couldn't compare #{other} with #{self.class}"
      end
    end
    alias eql? ==
  end
end
