# frozen_string_literal: true

require 'forwardable'
require 'logger'

require_relative 'instruction'
require_relative 'parameter'

module Intcode7
  # Represents an Intcode CPU initialized with a given memory contents
  class Computer
    extend Forwardable

    attr_reader :memory, :name
    attr_accessor :instruction_pointer
    alias m memory
    alias ip instruction_pointer
    alias ip= instruction_pointer=

    delegate %i[puts] => :@stdout
    delegate %i[gets] => :@stdin

    def initialize(
      name,
      memory,
      stdout: $stdout,
      stderr: $stderr,
      stdin: $stdin,
      logger: Logger.new($stderr, level: :info)
    )
      @name = name
      @memory = memory
      @instruction_pointer = 0
      @stdout = stdout
      @stderr = stderr
      @stdin = stdin
      @logger = logger.tap { |log| log.progname = name }
    end

    def run
      catch(:break) do
        loop do
          instruction = decode(fetch_instruction_data)

          @logger.debug { "#{name}: #{memory.inspect}" }
          @logger.debug { "#{name}: @#{instruction_pointer} => #{instruction}" }

          @instruction_pointer += instruction.length
          instruction.execute
        end
      end
      @logger.debug { "#{name} done: #{memory.inspect}" }

      @stdout.close unless @stdout == $stdout
      @stderr.close unless @stderr == $stderr
      @stdin.close unless @stdin == $stdin
    end

    private

    def decode(data)
      opcode = data.first % 100
      operation = INSTRUCTION_SET[opcode]
      param_data = data.slice(Operation::OPCODE_LENGTH, operation.parameters)
      mode_data = data.first / 100
      parameters = Parameter.decode(param_data, self, mode_data: mode_data)
      Instruction.new(operation, parameters, computer: self)
    end

    def fetch_instruction_data
      memory.slice(@instruction_pointer, Instruction::MAX_LENGTH)
    end
  end
end
