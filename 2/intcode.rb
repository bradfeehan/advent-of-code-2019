#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'logger'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} [-v] <input>" unless (1..2).include?(ARGV.count)

require_relative 'calculator'

logger_level = ARGV.delete('-v').nil? ? :info : :debug
logger = Logger.new($stderr, level: logger_level)

calculator = Intcode2::Calculator.new input_file: ARGV.first, logger: logger
# puts calculator.result(noun: 12, verb: 2)

target = 19_690_720

(0..99).each do |noun|
  (0..99).each do |verb|
    logger.debug { "Trying: noun=#{noun}, verb=#{verb}" }
    result = calculator.result(noun: noun, verb: verb)
    logger.debug { "noun=#{noun}, verb=#{verb}: result=#{result}" }
    if result == target
      $stdout.puts "noun=#{noun}, verb=#{verb}: result=#{result}"
      break
    end
  rescue Intcode2::InstructionSet::UnknownOpcodeError => e
    logger.error { e }
  end
end
