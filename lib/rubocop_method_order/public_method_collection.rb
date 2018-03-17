# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class PublicMethodCollection < MethodCollection
    def initialize
      @initialize_found = false
      super
    end

    def ordered_methods
      if @initialize_found
        [:initialize] + (@methods - [:initialize]).sort
      else
        super
      end
    end

    def push(method_name)
      @initialize_found = true if method_name == :initialize
      super
    end
  end
end
