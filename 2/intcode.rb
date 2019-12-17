#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

require_relative 'calculator'

calculator = Intcode2::Calculator.new input_file: ARGV.first
# puts calculator.result(noun: 12, verb: 2)

target = 19_690_720

(0..99).each do |noun|
  (0..99).each do |verb|
    warn "Trying: noun=#{noun}, verb=#{verb}"
    result = calculator.result(noun: noun, verb: verb)
    warn "noun=#{noun}, verb=#{verb}: result=#{result}"
    if result == target
      $stdout.puts "noun=#{noun}, verb=#{verb}: result=#{result}"
      break
    end
  rescue Intcode2::InstructionSet::UnknownOpcodeError => e
    warn e
  end
end
