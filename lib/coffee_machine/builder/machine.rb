# frozen_string_literal: true

require 'coffee_machine/beverage'
require 'coffee_machine/constant'
require 'coffee_machine/ingredient'
require 'coffee_machine/machine'
require 'coffee_machine/parser/json'
require 'coffee_machine/validator/input_data'

module CoffeeMachine
  module Builder
    # Builder classes are used to build complex objects which require a lof
    # of operations.
    # Builder::Machine class is used to build Machine class object from
    # parsed data and return it.
    class Machine
      # @param {String} file_name
      # @return {CoffeeMachine::Machine}
      def self.call(file_name)
        new.build(file_name)
      end

      def initialize
        @machine = CoffeeMachine::Machine.new
      end

      # @param {String} file_name
      # @return {CoffeeMachine::Machine}
      def build(file_name)
        data = parse_file(file_name)
        validate_data(data)
        set_outlets(data)
        add_ingredients(data)
        add_beverages(data)

        @machine
      end

      private

        # @param {String} file_name
        # @return {Hash} - Parsed file data
        def parse_file(file_name)
          Parser::Json.call(file_name)
        end

        # @param {Hash} data - Parsed file data
        def validate_data(data)
          Validator::InputData.call(data)
        end

        # @param {Hash} data - Parsed file data
        def set_outlets(data)
          outlets_data = machine_data(data)[Constant::INPUT_KEYS[:OUTLETS][:KEY]]
          @machine.set_outlets!(outlets_data[Constant::INPUT_KEYS[:OUTLETS][:COUNT]])
        end

        # @param {Hash} data - Parsed file data
        def add_ingredients(data)
          ingredients_data = machine_data(data)[Constant::INPUT_KEYS[:INGREDIENTS]]

          ingredients_data.each do |name, quantity|
            ingredient_obj = Ingredient.new(name, quantity)
            @machine.add_ingredients!(ingredient_obj)
          end
        end

        # @param {Hash} data - Parsed file data
        def add_beverages(data)
          beverages_data = machine_data(data)[Constant::INPUT_KEYS[:BEVERAGES]]

          beverages_data.each do |name, ingredients|
            beverage_obj = Beverage.new(name, ingredients)
            @machine.add_beverages!(beverage_obj)
          end
        end

        # @param {Hash} data - Parsed file data
        def machine_data(data)
          @machine_data ||= data[Constant::INPUT_KEYS[:MACHINE]]
        end
    end
  end
end
