# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class MethodNodeCollection
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def offenses
      nodes.reject { |node| method_order_correct?(node) }.map do |node|
        is_after = expected_method_index(node) > nodes.index(node)

        {
          direction: is_after ? 'after' : 'before',
          node: node,
          other_node: is_after ? previous_method_node(node) : next_method_node(node)
        }
      end
    end

    def push(method_node)
      @nodes << method_node
      self
    end

    private

    def expected_method_index(method_node)
      ordered_nodes.index(method_node)
    end

    def method_order_correct?(method_node)
      nodes.index(method_node) == ordered_nodes.index(method_node)
    end

    def next_method_node(method_node)
      expected_index = expected_method_index(method_node)
      return if expected_index.nil?
      return if expected_index + 1 >= nodes.size
      ordered_nodes[expected_index + 1]
    end

    def ordered_nodes
      nodes.sort_by(&:method_name)
    end

    def previous_method_node(method_node)
      expected_index = expected_method_index(method_node)
      return if expected_index.nil?
      return if (expected_index - 1).negative?
      ordered_nodes[expected_index - 1]
    end
  end
end
