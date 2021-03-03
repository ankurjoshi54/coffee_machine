# frozen_string_literal: true

require 'coffee_machine/constant'
require 'coffee_machine/error'
require 'coffee_machine/util'

module CoffeeMachine
  module Validator
    class Error < CoffeeMachine::Error; end

    # Validator is used to validate the input data. This will make subsequent
    # logic easy to write as we are sure of the data format & its validity.
    #
    # Currently all the logic is in a single class but later on we can create
    # separate validator class for Machine, Outlets, Beverages and Ingredients.
    # Then this call will serve as orchestrator which will call other validator
    # classes.
    class InputData
      # @param {Hash} parsed_data
      def self.call(parsed_data)
        new(parsed_data).validate
      end

      # @param {Hash} parsed_data
      def initialize(parsed_data)
        @parsed_data = parsed_data
        @error = []
      end

      def validate
        validate_machine
        validate_outlets
        validate_ingredients
        validate_beverages
      rescue KeyError => e
        @error.push(e.message)
      ensure
        raise_validation_error
      end

      private
        def validate_machine
          Util.fetch_with_error(@parsed_data, Constant::INPUT_KEYS[:MACHINE])
        end

        # @raise {InvalidType}
        def validate_outlets
          outlets = Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:OUTLETS][:KEY])

          unless outlets.is_a?(Hash)
            raise TypeError.new("#{Constant::INPUT_KEYS[:OUTLETS][:KEY]} is not of type #{Hash}")
          end

          unless outlets[Constant::INPUT_KEYS[:OUTLETS][:COUNT]].is_a?(Numeric)
            @error.push \
              "#{Constant::INPUT_KEYS[:OUTLETS][:KEY]}.#{Constant::INPUT_KEYS[:OUTLETS][:COUNT]}" +
                " is not of type #{Numeric}"
          end
        rescue KeyError, TypeError => e
          @error.push(e.message)
        end

        def validate_ingredients
          ingredients = Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:INGREDIENTS])

          unless ingredients.is_a?(Hash)
            raise TypeError.new("#{Constant::INPUT_KEYS[:INGREDIENTS]} is not of type #{Hash}")
          end

          ingredients.each do |name, quantity|
            unless quantity.is_a?(Numeric)
              @error.push \
                "#{Constant::INPUT_KEYS[:INGREDIENTS]}.#{name} is not of type #{Numeric}"
            end
          end
        rescue KeyError, TypeError => e
          @error.push(e.message)
        end

        def validate_beverages
          beverages = Util.fetch_with_error(machine_data, Constant::INPUT_KEYS[:BEVERAGES])

          unless beverages.is_a?(Hash)
            raise TypeError.new("#{Constant::INPUT_KEYS[:BEVERAGES]} is not of type #{Hash}")
          end

          beverages.each do |name, beverages|
            unless beverages.is_a?(Hash)
              @error.push \
                "#{Constant::INPUT_KEYS[:BEVERAGES]}.#{name} is not of type #{Hash}"
            end
          end
        rescue KeyError, TypeError => e
          @error.push(e.message)
        end

        def raise_validation_error
          return if @error.length == 0

          raise Error.new(@error.join("\n"))
        end

        def machine_data
          @machine_data ||= @parsed_data[Constant::INPUT_KEYS[:MACHINE]]
        end
    end
  end
end