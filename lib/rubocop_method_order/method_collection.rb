# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class MethodCollection
    attr_reader :methods

    def initialize
      @methods = []
    end

    def ordered_methods
      @methods.sort
    end

    def push(method_name)
      @methods << method_name
      self
    end
  end
end
