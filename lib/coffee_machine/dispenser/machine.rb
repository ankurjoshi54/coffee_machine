# frozen_string_literal: true

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
          @beverages.each do |_, beverage|
            @work_queue.push(beverage)
          end
        end

        def execute_work_in_queue
          threads = []
          @outlets.times do
            threads << Thread.new do
              loop do
                begin
                  beverage = @work_queue.pop(true)
                rescue ThreadError
                  Thread::exit
                end
                @result.push(beverage.dispense(@ingredients))
              end
            end
          end

          threads.each(&:join)
        end
    end
  end
end
