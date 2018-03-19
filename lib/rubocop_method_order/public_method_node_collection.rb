# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class PublicMethodNodeCollection < MethodNodeCollection
    def initialize
      @initialize_node = nil
      super
    end

    def ordered_nodes
      if @initialize_node
        [@initialize_node] + (super - [@initialize_node])
      else
        super
      end
    end

    def push(method_node)
      @initialize_node = method_node if method_node.method_name == :initialize
      super(method_node)
    end
  end
end
