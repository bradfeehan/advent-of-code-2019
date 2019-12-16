# frozen_string_literal: true

require 'forwardable'

module Intcode
  # Represents an Intcode parameter and mode
  class Parameter
    extend Forwardable

    delegate %i[+ * < == != zero?] => :to_int

    def self.decode(values, computer, mode_data:)
      mode_data *= 10
      values.map do |value|
        new(value, mode: MODES[(mode_data /= 10) % 10], computer: computer)
      end
    end

    def initialize(param, mode:, computer:)
      @param = param
      @mode = mode
      @computer = computer
    end

    def read
      @mode.read(@param, from: @computer)
    end
    alias to_int read

    def write(value)
      @mode.write(@param, with: value, to: @computer)
    end

    def mnemonic
      "#{@mode.mnemonic % @param}=#{read}"
    end

    def coerce(other)
      return [other, to_int] if other.is_a? Integer

      raise TypeError, "#{self.class} can't be coerced into #{other.class}"
    end

    def to_s
      @mode.mnemonic % @param
    end

    def inspect
      "#<#{self.class} #{self}>"
    end

    # Represents a Parameter Mode
    class Mode
      attr_reader :modecode, :mnemonic

      def initialize(modecode, mnemonic, r: nil, w: nil)
        @modecode = modecode
        @mnemonic = mnemonic
        @read_block = r
        @write_block = w
      end

      def read(param, from:)
        from.instance_exec(param, &@read_block)
      end

      def write(param, with:, to:)
        to.instance_exec(param, with, &@write_block)
      end

      def to_s
        @modecode.to_s
      end

      def inspect
        "#<#{self.class} modecode=#{self}>"
      end
    end

    MODES = {
      0 => Mode.new(0, '(%d)', r: ->(a) { m[a] }, w: ->(a, v) { m[a] = v }),
      1 => Mode.new(1, '%d', r: :itself.to_proc)
    }.freeze
  end
end
