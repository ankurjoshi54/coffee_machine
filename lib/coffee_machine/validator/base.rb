# frozen_string_literal: true

require 'coffee_machine/constant'
require 'coffee_machine/error'
require 'coffee_machine/util'

module CoffeeMachine
  module Validator
    # Validator is used to validate the input data. This will make subsequent
    # logic easy to write as we are sure of the data format & its validity.
    #
    # Currently all the logic is in a single class but later on we can create
    # separate validator class for Machine, Outlets, Beverages and Ingredients.
    # Then we will create a class that will serve as orchestrator which
    # will call other validator classes.
    class Base
      # @param {Hash} parsed_data
      def self.call(parsed_data)
        new(parsed_data).validate
      end

      # @param {Hash} parsed_data
      def initialize(parsed_data)
        @parsed_data = parsed_data
      end

      def validate
        validate_machine
        validate_outlets
        validate_ingredients
        validate_beverages
      end

      private
        def validate_machine
          Util.fetch_with_error(@parsed_data, Constant::INPUT_KEYS[:MACHINE])
        end

        # @raise {InvalidType}
        def validate_outlets
          outlets = Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:OUTLETS][:KEY])

          unless outlets[Constant::INPUT_KEYS[:OUTLETS][:COUNT]].is_a?(Numeric)
            raise InvalidType.new(outlets[Constant::INPUT_KEYS[:OUTLETS][:COUNT]], Numeric)
          end
        end

        def validate_ingredients
          # TODO: Add validation for each ingredient
          Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:INGREDIENTS])
        end

        def validate_beverages
          # TODO: Add validation for each beverage
          Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:BEVERAGES])
        end

        def machine_data
          @machine_data ||= Util.fetch_with_error(@parsed_data, Constant::INPUT_KEYS[:MACHINE])
        end
    end
  end
end