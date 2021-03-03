# frozen_string_literal: true

require 'coffee_machine/constant'
require 'coffee_machine/error'

module CoffeeMachine
  module Dispenser
    # Dispenser::Beverage is used to encapsulate the logic of preparing/dispensing
    # a beverage.
    #
    # As we are obtaining lock on the ingredient, dead-lock may occur.
    # To prevent it when the lock is obtained on the ingredients then we need
    # to make sure that we don't get circular dependency.
    # For e.g if Beverage1 and Beverage2 both require Ingredient1 and Ingredient2
    # then if Beverage1 obtained lock on Ingredient1 and Beverage2 obtained lock
    # on Ingredient2 then dead-lock will occur as both beverages are blocked/waiting
    # on each other.
    #
    # To prevent this we are storing ingredients after sorting it in beverages and
    # then obtaining lock on the ingredients in the sorted order. In the above example
    # Beverage1 and Beverage2 will both first try to take lock on Ingredient1 and
    # after obtaining lock on it, will try to obtain lock on Ingredient2. This
    # is because after sorting Ingredient1 will come before Ingredient2.
    class Beverage
      class BeverageDispenseError < Error; end

      # @param {CoffeeMachine::Beverage} beverage
      # @param {Hash} total_ingredients
      # @return {String}
      def self.call(beverage, total_ingredients)
        new(beverage, total_ingredients).dispense
      end

      # @param {CoffeeMachine::Beverage} beverage
      # @param {Hash} total_ingredients
      def initialize(beverage, total_ingredients)
        @beverage = beverage
        @total_ingredients = total_ingredients
      end

      # @return {String}
      def dispense
        validate_ingredients_availability
        thread_safe_beverage_dispense do
          validate_ingredients_quantity
          prepare_beverage
        end

        Constant::OUTPUT_MESSAGE[:PREPARED] % @beverage.name
      rescue BeverageDispenseError => e
        return e.message
      end

      private
        # Prepare beverage in the thread safe manner by first obtaining lock on
        # the required ingredients and then performing the action.
        def thread_safe_beverage_dispense
          acquire_lock_on_ingredients
          begin
            yield if block_given?
          ensure
            release_lock_on_ingredients
          end
        end

        def validate_ingredients_availability
          @beverage.ingredients.each do |name, _|
            unless @total_ingredients[name]
              raise BeverageDispenseError.new \
                Constant::OUTPUT_MESSAGE[:NOT_AVAILABLE] % [@beverage.name, name]
            end
          end
        end

        def validate_ingredients_quantity
          @beverage.ingredients.each do |name, quantity|
            unless @total_ingredients[name].sufficient?(quantity)
              raise BeverageDispenseError.new \
                Constant::OUTPUT_MESSAGE[:NOT_SUFFICIENT] % [@beverage.name, name]
            end
          end
        end

        def prepare_beverage
          @beverage.ingredients.each do |name, quantity|
            @total_ingredients[name].consume!(quantity)
          end
        end

        def acquire_lock_on_ingredients
          @beverage.ingredients.each do |name, _|
            @total_ingredients[name].lock
          end
        end

        def release_lock_on_ingredients
          @beverage.ingredients.each do |name, _|
            @total_ingredients[name].unlock
          end
        end
    end
  end
end
