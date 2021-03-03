#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'coffee_machine/builder/machine'
require 'coffee_machine/validator/input_data'

if ARGV[0]
  begin
    coffee_machine = CoffeeMachine::Builder::Machine.call(ARGV[0])
    output = coffee_machine.run
    until output.empty?
      STDOUT.puts output.pop
    end
  rescue CoffeeMachine::Validator::Error => e
    STDOUT.puts e.message
  end
else
  STDOUT.puts 'Please provide the input file.'
end
