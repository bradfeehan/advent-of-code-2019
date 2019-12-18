# frozen_string_literal: true

require 'forwardable'

module Intcode9
  # Represents an Intcode parameter and mode
  class Parameter
    extend Forwardable

    delegate %i[+ * < == != zero?] => :to_int

    def self.decode(values, computer, mode_data:)
      mode_data *= 10
      values.map do |value|
        modecode = (mode_data /= 10) % 10
        new value, mode: MODES.fetch(modecode), computer: computer
      end
    end

    def initialize(param, mode:, computer:)
      raise ArgumentError, 'Param is nil' if param.nil?
      raise ArgumentError, 'Mode is nil' if mode.nil?

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
      attr_reader :mnemonic

      def initialize(mnemonic, r: nil, w: nil)
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
        @mnemonic.to_s
      end

      def inspect
        "#<#{self.class} modecode=#{self}>"
      end
    end

    MODES = {
      0 => Mode.new('(%d)', r: ->(a) { m[a] }, w: ->(a, v) { m[a] = v }),
      1 => Mode.new('%d', r: :itself.to_proc),
      2 => Mode.new('%+d', r: ->(d) { m[ro + d] }, w: ->(d, v) { m[ro + d] = v })
    }.freeze
  end
end
