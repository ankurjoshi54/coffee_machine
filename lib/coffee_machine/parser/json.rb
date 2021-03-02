# frozen_string_literal: true

require 'json'

require 'coffee_machine/parser/base'

module CoffeeMachine
  module Parser
    class Json < Base
      # @param {String} input_str
      # @return {Hash} - Parsed data from the file
      def parse_str(input_str)
        JSON.parse(input_str, symbolize_names: true)
      end
    end
  end
end
