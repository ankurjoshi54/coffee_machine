# frozen_string_literal: true

require 'coffee_machine/error'
require 'coffee_machine/util'

module CoffeeMachine
  module Parser
    # Parsers are used to read the file_data and parse the result.
    # Currently only JSON parser is implement. In the future, we can crate
    # XML, YAML etc. parser for different input format. All parsers will
    # inherit this base class.
    class Base
      # @param {String} file_name
      def self.call(file_name)
        new.parse(file_name)
      end

      # @param {String} file_name
      # @return {Hash} - Parsed data from the file
      def parse(file_name)
        input_str = get_file_data(file_name)
        parse_str(input_str)
      end

      private

        # @param {String} file_name
        # @return {String}
        def get_file_data(file_name)
          File.read(file_name)
        end

        # @param {String} input_str
        # @raise {MethodNotImplemented}
        def parse_str(input_str)
          raise MethodNotImplemented.new(__method__, self.class)
        end
    end
  end
end
