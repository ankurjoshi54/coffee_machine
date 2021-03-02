# frozen_string_literal: true

module CoffeeMachine
  class Error < StandardError; end

  class KeyNotPresent < Error
    # @param {Hash} hash
    # @param {String} key
    def initialize(hash, key)
      message = "Key `#{key}` is not present on hash #{hash}"
      super(message)
    end
  end

  class InvalidType < Error
    # @param {String} value
    # @param {Class} type
    def initialize(value, type)
      message = "`#{value}` is not of type `#{type}`"
      super(message)
    end
  end

  class MethodNotImplemented < Error
    # @param {String} method_name
    # @param {String} class_name
    def initialize(method_name, class_name)
      message = "Method `#{method_name}` is not implemented by class `#{class_name}`"
      super(message)
    end
  end

  class LockRequired < Error
    # @param {String} method_name
    # @param {Object} object
    def initialize(method_name, class_name)
      message = "Obtain lock on the #{class_name} before performing #{method_name}"
      super(message)
    end
  end
end
