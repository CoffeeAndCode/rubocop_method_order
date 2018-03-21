# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class PublicMethodNodeCollection < MethodNodeCollection
    def initialize
      @initialize_node = nil
      super
    end

    def push(method_node)
      @initialize_node = method_node if method_node.method_name == :initialize
      super(method_node)
    end

    def sort(one, two)
      if @initialize_node
        return 0 if one == @initialize_node && two == @initialize_node
        return -1 if one == @initialize_node
        return 1 if two == @initialize_node
      end
      super
    end
  end
end
