# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Style
      # Retain order in your Ruby classes/modules by requiring methods to be
      # sorted alphabetically in permission groups. This assumes you start with
      # public methods and that you're using `private` or `protected` to
      # delineate between groupings of methods.
      class MethodOrder < Cop
        MSG = 'Method `%<method>s` should come %<direction>s the method' \
          ' `%<other_method>s`.'

        def on_class(node)
          public_methods = RuboCopMethodOrder::PublicMethodCollection.new

          begin_node = node.child_nodes.select { |x| x&.type == :begin }.first
          nodes = begin_node.nil? ? node.child_nodes : begin_node.child_nodes
          process_methods(public_methods, nodes)
        end
        alias_method :on_module, :on_class

        private

        def check_node(public_methods, node)
          method_index = public_methods.methods.index(node.method_name)
          expected_method_index = public_methods.ordered_methods.index(node.method_name)
          return if expected_method_index == method_index

          direction = 'before'
          other_method = public_methods.ordered_methods[expected_method_index + 1]

          if expected_method_index > method_index
            direction = 'after'
            other_method = public_methods.ordered_methods[expected_method_index - 1]
          end

          add_offense(node, location: :expression, message: message(
            node.method_name,
            other_method,
            direction
          ))
        end

        def enabled_at_line?(node)
          processed_source.comment_config.cop_enabled_at_line?(self, node.first_line)
        end

        def message(method_name, following_method_name, direction)
          format(MSG, direction: direction, method: method_name, other_method: following_method_name)
        end

        def process_methods(public_methods, nodes)
          mode = :public
          method_groups = nodes.each_with_object({}) do |obj, memo|
            if obj.type == :def
              memo[mode] = [] if memo[mode].nil?
              memo[mode] << obj if enabled_at_line?(obj)
            end

            mode = obj.method_name if obj.type == :send && %i[private protected].include?(obj.method_name)
          end

          method_nodes = method_groups[:public].select { |n| n.type == :def }
          method_nodes.each { |def_node| public_methods.push(def_node.method_name) }
          method_nodes.each { |def_node| check_node(public_methods, def_node) }
        end
      end
    end
  end
end
