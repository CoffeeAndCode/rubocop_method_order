# frozen_string_literal: true

module RuboCopMethodOrder
  # Hold collection of public instance methods that has custom sorted order.
  class MethodNodeCollection
    attr_reader :nodes

    def initialize
      @nodes = []
    end

    def offenses
      nodes.reject { |node| definition_order_correct?(node) }.map do |node|
        {
          node: node,
          other_node: previous_node_from_definition_order(node)
        }
      end
    end

    def push(method_node)
      @nodes << method_node
      self
    end

    # Build a hash for every node that is not at the correct, final position
    # which includes any nodes that need to be moved. Used for autocorrecting.
    def replacements
      nodes.reject { |node| method_order_correct?(node) }.each_with_object({}) do |node, obj|
        node_to_replace = nodes[expected_method_index(node)]

        obj[node] = {
          node => node_to_replace,
          node_to_replace => nodes[expected_method_index(node_to_replace)]
        }
      end
    end

    private

    def definition_order_correct?(method_node)
      previous_node_from_definition_order(method_node).nil?
    end

    def expected_method_index(method_node)
      ordered_nodes.index(method_node)
    end

    def method_order_correct?(method_node)
      nodes.index(method_node) == ordered_nodes.index(method_node)
    end

    def ordered_nodes
      nodes.sort(&method(:sort))
    end

    def previous_node_from_definition_order(method_node)
      index = nodes.index(method_node)
      nodes[0..index].find { |comp_node| sort(comp_node, method_node).positive? }
    end

    def sort(one, two)
      one.method_name <=> two.method_name
    end
  end
end
