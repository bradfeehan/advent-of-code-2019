# frozen_string_literal

require 'forwardable'

module NanoFactory
  def self.Inventory(value)
    case value
    when Inventory then value
    when Hash then Inventory.new(value)
    else raise TypeError, "Unknown inventory #{value.inspect}"
    end
  end

  # Represents a list of resources and quantities
  class Inventory
    extend Forwardable

    delegate %i[all? each empty? entries map] => :@contents

    def initialize(contents = {})
      @contents = contents
    end

    def [](type)
      @contents.fetch(type, 0)
    end

    def []=(type, value)
      @contents[type] = value
    end

    def ==(other)
      return self == self.class.new(other) if other.is_a? Hash

      assert_same_type(other, operation: 'comparison')
      entries == other.entries
    end
    alias eql? ==

    def +(other)
      assert_same_type(other, operation: 'addition')
      contents = (types + other.types).map do |type|
        [type, self[type] + other[type]]
      end

      self.class.new(contents.to_h)
    end

    def -(other)
      assert_same_type(other, operation: 'subtraction')
      raise ArgumentError, 'Negative inventory' if other.negative?

      transform { |type, count| [type, count - other[type]] }
    end

    def *(other)
      case other
      when Integer then transform { |type, count| [type, count * other] }
      else raise "Can't multiply #{self.class} by #{other.class}"
      end
    end

    def excluding(other)
      (self - other).positive_only
    end

    def positive_only
      select { |_type, count| count.positive? }
    end

    def negative?
      @contents.any? { |_type, count| count.negative? }
    end

    def to_s
      @contents.map { |type, count| "#{count} #{type}" }.join(', ')
    end

    def types
      @contents.keys
    end

    def inspect
      "#<#{self.class} (#{self})>"
    end

    # Delegated to @contents

    def transform(&block)
      apply_enumerable_method(:map, &block)
    end

    def select(&block)
      apply_hash_method(:select, &block)
    end

    def reject(&block)
      apply_hash_method(:reject, &block)
    end

    private

    def apply_enumerable_method(method_name, &block)
      self.class.new(@contents.public_send(method_name, &block).to_h)
    end

    def apply_hash_method(method_name, &block)
      self.class.new(@contents.public_send(method_name, &block))
    end

    def assert_same_type(other, operation:)
      return if other.class == self.class

      raise TypeError, "can't do #{operation} on #{self.class} and #{other.class}"
    end
  end
end
