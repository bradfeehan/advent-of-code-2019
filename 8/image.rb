# frozen_string_literal: true

# Represents an image in Space Image Format
class SpaceImage
  attr_reader :height, :width

  def initialize(data, height:, width:)
    @data = data
    @height = height
    @width = width
  end

  def checksum
    layer = layers.min_by { |layer| layer.count('0') }
    layer.count('1') * layer.count('2')
  end

  def decode
    rendered = layers.reduce(['2'] * width * height) do |image, layer|
      image.zip(layer).map do |image_pixel, layer_pixel|
        image_pixel == '2' ? layer_pixel : image_pixel
      end
    end

    rendered
      .each_slice(width)
      .map { |row| row.map { |px| px == '0' ? '##' : '  ' }.join('') }
      .join("\n")
  end

  def layers
    @data.each_char.each_slice(width * height)
  end
end
