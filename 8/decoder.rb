#!/usr/bin/env ruby
#
# frozen_string_literal: true

require 'forwardable'

def abort(message, status: 1)
  warn message
  exit status
end

abort "Usage: #{$PROGRAM_NAME} <inputfile>" unless ARGV.count == 1

require_relative 'image'

data = File.read(ARGV.first)
image = SpaceImage.new(data, height: 6, width: 25)
puts image.decode
