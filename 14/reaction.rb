# frozen_string_literal: true

module NanoFactory
  # Represents a single reaction that the nanofactory can do
  class Reaction
    def self.parse(string)
      reactants, product = string.split('=>', 2).map do |side|
        side.strip.split(',').map do |reactant|
          count, name = reactant.strip.split(' ', 2)
          [name.to_sym, Integer(count)]
        end.to_h
      end

      new(reactants, product)
    end

    attr_reader :reactants, :product

    def initialize(reactants, product)
      @reactants = reactants
      @product = product
    end

    def makes?(type)
      product.key?(type)
    end

    def to_s
      sides = [reactants, product].map do |side|
        side.map { |count, name| "#{count} #{name}" }.join(', ')
      end
      sides.join(' => ')
    end

    def inspect
      "#<#{self.class} (#{self})>"
    end

    def ==(other)
      case other
      when self.class
        other.product == product && other.reactants == reactants
      else raise TypeError, "couldn't compare #{other} with #{self.class}"
      end
    end
    alias eql? ==
  end
end
