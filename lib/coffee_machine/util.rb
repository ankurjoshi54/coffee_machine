# frozen_string_literal: true

require 'coffee_machine/error'

module CoffeeMachine
  module Util
    # @param {Hash} hash
    # @param {String, Symbol} key
    # @return {Object}
    # @raise {KeyNotPresent}
    def self.fetch_with_error(hash, key)
      hash.fetch(key) do |key|
        raise KeyError.new("Key not found: #{key}")
      end
    end
  end
end
