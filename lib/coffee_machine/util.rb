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

    # Executes work in threads by initializing threads equal to the thread_count param
    # and execute work parallely among those threads. Also stores the result in a
    # queue if the result_queue is provided.
    #
    # @param {Integer} thread_count
    # @param {Queue<Proc, Array<Object>>} work_queue - Queue containing proc and its parameters
    # @param {Queue<Object>} result_queue
    def self.execute_work_with_threads(thread_count, work_queue, result_queue = nil)
      threads = []
      thread_count.times do
        threads << Thread.new do
          loop do
            begin
              action_proc, action_parameters = work_queue.pop(true)
            rescue ThreadError
              Thread::exit
            end
            result = action_proc.call(*action_parameters)
            if result_queue
              result_queue.push(result)
            end
          end
        end
      end

      threads.each(&:join)
    end
  end
end
