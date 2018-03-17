# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class MethodCollection
    attr_reader :methods

    def initialize
      @methods = []
    end

    def expected_method_index(method_name)
      ordered_methods.index(method_name)
    end

    def method_order_correct?(method_name)
      methods.index(method_name) == ordered_methods.index(method_name)
    end

    def next_method_name(method_name)
      expected_index = expected_method_index(method_name)
      return if expected_index.nil?
      return if expected_index + 1 >= methods.size
      ordered_methods[expected_index + 1]
    end

    def ordered_methods
      @methods.sort
    end

    def previous_method_name(method_name)
      expected_index = expected_method_index(method_name)
      return if expected_index.nil?
      return if (expected_index - 1).negative?
      ordered_methods[expected_index - 1]
    end

    def push(method_name)
      @methods << method_name
      self
    end
  end
end
