#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'coffee_machine/builder/machine'

if ARGV[0]
  coffee_machine = CoffeeMachine::Builder::Machine.call(ARGV[0])
  output = coffee_machine.run
  until output.empty?
    STDOUT.puts output.pop
  end
else
  STDOUT.puts 'Please provide the input file'
end
