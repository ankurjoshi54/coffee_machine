# frozen_string_literal: true

require 'coffee_machine/util'

module CoffeeMachine
  module Dispenser
    # Dispenser::Machine is used to encapsulate logic of preparing/dispensing
    # multiple beverages from machine.
    #
    # To serve N (number of outlets) beverages in parallel we are gonna use Threads.
    # A thread-safe Queue implementation will be used to keep track of beverages
    # we want to prepare.
    # We will create N (number of outlets) threads which will pick the beverage
    # the queue until the queue is empty and prepare the beverage.
    class Machine
      # @param {Numeric} outlets
      # @param {Hash<String, Beverage>} beverages
      # @param {Hash<String, Ingredient>} ingredients
      # @return {Queue<String>}
      def self.call(outlets, beverages, ingredients)
        new(outlets, beverages, ingredients).dispense
      end

      # @param {Numeric} outlets
      # @param {Hash<String, Beverage>} beverages
      # @param {Hash<String, Ingredient>} ingredients
      # @return {Queue<String>}
      def initialize(outlets, beverages, ingredients)
        @outlets = outlets
        @beverages = beverages
        @ingredients = ingredients
        @work_queue = Queue.new
        @result = Queue.new
      end

      # @return {Queue<String>}
      def dispense
        add_work_to_queue
        execute_work_in_queue

        @result
      end

      private
        def add_work_to_queue
          @beverages.each do |_, beverage_obj|
            action_proc = lambda do |beverage, ingredients|
              beverage.dispense(ingredients)
            end
            action_parameters = [beverage_obj, @ingredients]

            @work_queue.push([action_proc, action_parameters])
          end
        end

        def execute_work_in_queue
          Util.execute_work_with_threads(@outlets, @work_queue, @result)
        end
    end
  end
end
