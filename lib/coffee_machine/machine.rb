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
    def set_outlets(count)
      @outlets = count
    end

    # @param {String} name - Name of the ingredient
    # @param {Ingredient} ingredient - Ingredient's object
    def add_ingredients(name, ingredient)
      return if @ingredients[name]

      @ingredients[name] = ingredient
    end

    # @param {String} name - Name of the beverage
    # @param {Beverage} beverage - Beverage's object
    def add_beverages(name, beverage)
      return if @beverages[name]

      @beverages[name] = beverage
    end

    # @return {Queue<String>} - Queue containing output for all beverages
    def run
      Dispenser::Machine.call(@outlets, @beverages, @ingredients)
    end
  end
end
