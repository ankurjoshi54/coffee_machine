# frozen_string_literal: true

module CoffeeMachine
  module Constant
    INPUT_KEYS = {
      MACHINE: :machine,
      OUTLETS: { KEY: :outlets, COUNT: :count_n }.freeze,
      INGREDIENTS: :total_items_quantity,
      BEVERAGES: :beverages
    }.freeze

    OUTPUT_MESSAGE = {
      PREPARED: '%s is prepared'.freeze,
      NOT_AVAILABLE: '%s cannot be prepared because %s is not available'.freeze,
      NOT_SUFFICIENT: '%s cannot be prepared because item %s is not sufficient'.freeze
    }
  end
end
