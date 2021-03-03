# frozen_string_literal: true

require 'coffee_machine/constant'

RSpec.describe 'CoffeeMachine spec' do
  EXECUTABLE_PATH = 'lib/coffee_machine.rb'
  VALID_INPUT_PATH = 'spec/assets/valid_input.json'
  VALID_INPUT_WITHOUT_INGREDIENT = 'spec/assets/valid_input_without_ingredients.json'
  INVALID_INPUT_PATH = 'spec/assets/invalid_input.json'

  describe 'with valid input file' do
    it 'perform CoffeeMachine logic and print correct output to stdout' do
      expected_output = [
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:PREPARED] % 'hot_tea',
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:PREPARED] % 'hot_coffee',
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:NOT_AVAILABLE] % %w(green_tea green_mixture),
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:NOT_SUFFICIENT] % %w(black_tea hot_water)
      ]

      expect { system %(#{EXECUTABLE_PATH} #{VALID_INPUT_PATH}) }.to \
        output(include(*expected_output)).to_stdout_from_any_process
    end

    it 'without ingredients, all beverages will not be available' do
      expected_output = [
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:NOT_AVAILABLE] % %w(hot_tea ginger_syrup),
        CoffeeMachine::Constant::OUTPUT_MESSAGE[:NOT_AVAILABLE] % %w(hot_coffee ginger_syrup)
      ]

      expect { system %(#{EXECUTABLE_PATH} #{VALID_INPUT_WITHOUT_INGREDIENT}) }.to \
        output(include(*expected_output)).to_stdout_from_any_process
    end
  end

  describe 'with invalid input file' do
    it 'takes file as input, perfrom validation on it and print errors to stdout' do
      expected_output = [
        'outlets.count_n is not of type Numeric',
        'total_items_quantity.ginger_syrup is not of type Numeric',
        'total_items_quantity.tea_leaves_syrup is not of type Numeric',
        'beverages.hot_tea is not of type Hash',
        'beverages.black_tea is not of type Hash'
      ]

      expect { system %(#{EXECUTABLE_PATH} #{INVALID_INPUT_PATH}) }.to \
        output(include(*expected_output)).to_stdout_from_any_process
    end
  end

  it 'output required message to stdout if the file is not provided' do
    expect { system %(#{EXECUTABLE_PATH}) }.to \
      output(include('Please provide the input file.')).to_stdout_from_any_process
  end
end
