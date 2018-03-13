# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class PublicMethodCollection
    attr_reader :methods

    def initialize
      @initialize_found = false
      @methods = []
    end

    def ordered_methods
      if @initialize_found
        [:initialize] + (@methods - [:initialize]).sort
      else
        @methods.sort
      end
    end

    def push(method_name)
      @initialize_found = true if method_name == :initialize
      @methods << method_name
      self
    end
  end
end
