# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Style
      # Retain order in your Ruby classes by requiring methods to be sorted
      # alphabetically in permission groups. This assumes you start with public
      # methods and that you're using `private` or `protected` to delineate
      # between groupings of methods.
      class MethodOrder < Cop
        MSG = 'Method `%<method>s` should come %<direction>s the method' \
          ' `%<other_method>s`.'
        VERSION = '0.1.0'

        def on_begin(node)
          return unless node.parent&.type == :class

          mode = :public
          method_groups = node.children.each_with_object({}) do |obj, memo|
            if obj.type == :def
              memo[mode] = [] if memo[mode].nil?
              memo[mode] << obj
            end

            mode = obj.method_name if obj.type == :send && %i[private protected].include?(obj.method_name)
          end

          method_nodes = method_groups[:public].select { |n| n.type == :def }
          method_nodes.each { |def_node| @public_methods.push(def_node.method_name) }
          method_nodes.each { |def_node| check_node(def_node) }
        end

        def on_class(_node)
          @public_methods = RuboCopMethodOrder::PublicMethodCollection.new
        end

        private

        def check_node(node)
          method_index = @public_methods.methods.index(node.method_name)
          expected_method_index = @public_methods.ordered_methods.index(node.method_name)
          return if expected_method_index == method_index

          direction = 'before'
          other_method = @public_methods.ordered_methods[expected_method_index + 1]

          if expected_method_index > method_index
            direction = 'after'
            other_method = @public_methods.ordered_methods[expected_method_index - 1]
          end

          add_offense(node, location: :expression, message: message(
            node.method_name,
            other_method,
            direction
          ))
        end

        def message(method_name, following_method_name, direction)
          format(MSG, direction: direction, method: method_name, other_method: following_method_name)
        end
      end
    end
  end
end
