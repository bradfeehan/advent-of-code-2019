# frozen_string_literal: true

require 'logger'

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
      @target = target
      @logger = logger
    end

    def ore_for_target
      requirements_for_target[:ORE]
    end

    private

    def requirements_for_target
      @requirements_for_target ||= begin
        inventory = Hash.new(0)
        requirements = @target.dup
        requirements.default = 0

        until (target = remaining(requirements, inventory)).keys.all?(:ORE)
          @logger.debug { "inventory: #{inventory}" }
          @logger.debug { "requirements: #{requirements}" }
          @logger.debug { "target: #{target}" }
          target_type = target.keys.find { |type| type != :ORE }
          reaction = reactions.find { |candidate| candidate.makes? target_type }
          @logger.debug { "Reaction: #{reaction}" }

          raise 'No possible reaction' if reaction.nil?

          # Add the reactants to the requirements list
          reaction.reactants.each do |reactant_type, reactant_count|
            requirements[reactant_type] += reactant_count
          end

          # We have the products now, add them to inventory
          reaction.product.each do |product_type, product_count|
            inventory[product_type] += product_count
          end
        end

        requirements
      end
    end

    private

    def remaining(requirements, inventory)
      requirements.map do |type, count|
        [type, count - [inventory.fetch(type, 0), 0].max]
      end.select { |type, count| count.positive? }.to_h
      .tap { |result| result.default = 0 }
    end
  end
end
