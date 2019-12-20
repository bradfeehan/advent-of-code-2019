# frozen_string_literal: true

require 'logger'

require_relative 'inventory'
require_relative 'reaction'

module NanoFactory
  # Represents a recipe of reaction steps to be performed by the nanofactory
  class Recipe
    def self.load(filename, target:, logger: Logger.new($stderr, level: :info))
      reactions = File.open(filename) do |file|
        file.each_line(chomp: true).map { |line| Reaction.parse(line) }
      end

      new(reactions, target, logger: logger)
    end

    attr_reader :reactions

    def initialize(reactions, target, logger: Logger.new($stderr, level: :info))
      @reactions = reactions
      @target = NanoFactory::Inventory(target)
      @logger = logger
    end

    def ore_for_target
      requirements_for_target[:ORE]
    end

    private

    def requirements_for_target
      @requirements_for_target ||= begin
        inventory = Inventory.new
        requirements = @target.dup

        until (target = requirements.excluding(inventory)).types.all?(:ORE)
          reaction = reactions.find do |candidate_reaction|
            candidate_reaction.product.types.any? do |product_type|
              target.types.include?(product_type)
            end
          end

          raise 'No possible reaction' if reaction.nil?

          # Repeat multiple times, enough for a product to meet a target
          repetitions = reaction.product.map do |product_type, product_count|
            (target[product_type].to_f / product_count).ceil
          end

          @logger.debug { "Reaction: #{reaction * repetitions.min}" }

          # Add the reactants to the requirements list
          requirements += reaction.reactants * repetitions.min

          # We have the products now, add them to inventory
          inventory += reaction.product * repetitions.min
        end

        requirements
      end
    end
  end
end
