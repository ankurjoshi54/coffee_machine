# frozen_string_literal: true

require 'coffee_machine/error'

module CoffeeMachine
  # Mutex (locks) are used in ingredients to enabled thread-safe operations.
  class Ingredient
    # @param {String} name
    # @param {Numeric} quantity
    def initialize(name, quantity)
      @name = name
      @max_quantity = quantity
      @remaining_quantity = quantity
      @mutex = Mutex.new
    end

    # Obtain lock on the ingredient. Required to perform operations on
    # the ingredient like `consume!`
    def lock
      @mutex.lock
    end

    # Release lock on the ingredient to make it available for other threads.
    def unlock
      @mutex.unlock
    end

    # Reduce ingredients quantity as per the consumption.
    # Only allowed when the lock is obtained on the ingredient.
    #
    # @param {Numeric} quantity
    # @raise {LockRequired}
    # @raise {Error}
    def consume!(quantity)
      return LockRequired.new(__method__, self.class) unless @mutex.owned?
      return Error.new("Ingredient quantity is not sufficient.") if @remaining_quantity < quantity

      @remaining_quantity -= quantity
    end

    # @param {Numeric} quantity
    # @return {Boolean}
    def sufficient?(quantity)
      @remaining_quantity >= quantity
    end
  end
end
