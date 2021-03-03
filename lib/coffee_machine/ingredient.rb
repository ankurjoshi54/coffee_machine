# frozen_string_literal: true

require 'coffee_machine/error'

module CoffeeMachine
  # Mutex (locks) are used in ingredients to enabled thread-safe operations.
  class Ingredient
    LOW_QUANTITY_THRESHOLD_PERCENTAGE = 20

    attr_reader :name

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
      validate_lock
      if @remaining_quantity < quantity
        raise Error.new("Ingredient quantity is not sufficient.")
      end

      @remaining_quantity -= quantity
    end

    # @param {Numeric} quantity
    # @return {Boolean}
    def sufficient?(quantity)
      @remaining_quantity >= quantity
    end

    # Refill ingredients
    #
    # @raise {LockRequired}
    def refill!
      validate_lock

      @remaining_quantity = @max_quantity
    end

    # Return true if the remaining_quantity is lower than `LOW_QUANTITY_THRESHOLD_PERCENTAGE`
    # percent of max_quantity.
    #
    # @return {Boolean}
    def low_quantity?
      @remaining_quantity < (@max_quantity / LOW_QUANTITY_THRESHOLD_PERCENTAGE)
    end

    # Execute block passed on it after obtaining lock on the ingredient.
    def with_lock
      lock
      begin
        yield if block_given?
      ensure
        unlock
      end
    end

    private
      # Raise error if the lock is not obtained by current thread
      def validate_lock
        raise LockRequired.new(__method__, self.class) unless @mutex.owned?
      end
  end
end
