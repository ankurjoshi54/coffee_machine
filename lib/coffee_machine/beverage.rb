# frozen_string_literal: true

require 'coffee_machine/dispenser/beverage'

module CoffeeMachine
  class Beverage
    attr_reader :name, :ingredients

    # Sorting is done on the ingredients to prevent dead-lock.
    # Check CoffeeMachine::Dispenser::Beverage for more details.
    #
    # @param {String} name - Name of the beverage
    # @param {Hash} ingredients - Ingredients required for beverage
    def initialize(name, ingredients)
      @name = name
      @ingredients = ingredients.sort.to_h
    end

    # @param {Hash} total_ingredients - Hash of ingredients available in the machine
    # @return {String}
    def dispense(total_ingredients)
      Dispenser::Beverage.call(self, total_ingredients)
    end
  end
end
