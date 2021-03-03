# frozen_string_literal: true

require 'coffee_machine/dispenser/machine'

module CoffeeMachine
  class Machine
    def initialize
      @outlets = 0
      @ingredients = {}
      @beverages = {}
    end

    # @param {Numeric} count
    def set_outlets!(count)
      @outlets = count
    end

    # @param {Ingredient} ingredient - Ingredient's object
    def add_ingredients!(ingredient)
      return if @ingredients[ingredient.name]

      @ingredients[ingredient.name] = ingredient
    end

    # @param {Beverage} beverage - Beverage's object
    def add_beverages!(beverage)
      return if @beverages[beverage.name]

      @beverages[beverage.name] = beverage
    end

    # @return {Queue<String>} - Queue containing output for all beverages
    def run
      Dispenser::Machine.call(@outlets, @beverages, @ingredients)
    end

    # @return {Array<Ingredient>} - List of ingredients that are low on quantity
    def low_quantity_ingredients
      @ingredients.filter_map { |ingredient| ingredient if ingredient.low_quantity? }
    end

    def refill_low_quantity_ingredients!
      low_quantity_ingredients.each do |ingredient|
        ingredient.with_lock do
          ingredient.refill!
        end
      end
    end
  end
end
