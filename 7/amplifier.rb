# frozen_string_literal: true

require 'logger'

require_relative 'computer'

module Intcode7
  # Represents a single amplifier in the chain
  class Amplifier
    attr_reader :name, :stdin, :stdout

    def initialize(
      name,
      memory:,
      stdin:,
      stdout:,
      logger: Logger.new($stderr, level: :info)
    )
      @name = name
      @memory = memory.dup
      @stdin = stdin
      @stdout = stdout
      @logger = logger
    end

    def call
      computer.run
    end

    private

    def computer
      Computer.new(
        name,
        @memory.dup,
        stdout: @stdout,
        stdin: @stdin,
        logger: @logger
      )
    end
  end
end
