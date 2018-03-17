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
        include RangeHelp

        MSG = 'Method `%<method>s` should come %<direction>s the method `%<other_method>s`.'

        def autocorrect(node)
          lambda do |corrector|
            line = range_by_whole_lines(node.source_range)
            corrector.insert_before(line, "FIX ME!\n")
          end
        end

        def on_class(node)
          begin_node = node.child_nodes.select { |x| x&.type == :begin }.first
          nodes = begin_node.nil? ? node.child_nodes : begin_node.child_nodes
          process_methods(nodes)
        end
        alias on_module on_class

        private

        def check_node(collection, node)
          return if collection.method_order_correct?(node.method_name)

          method_index = collection.methods.index(node.method_name)
          expected_index = collection.expected_method_index(node.method_name)

          if expected_index > method_index
            add_offense(node, location: :expression, message: message(
              node.method_name,
              collection.previous_method_name(node.method_name),
              'after'
            ))
          else
            add_offense(node, location: :expression, message: message(
              node.method_name,
              collection.next_method_name(node.method_name),
              'before'
            ))
          end
        end

        def enabled_at_line?(node)
          processed_source.comment_config.cop_enabled_at_line?(self, node.first_line)
        end

        def message(method_name, following_method_name, direction)
          format(MSG,
                 direction: direction,
                 method: method_name,
                 other_method: following_method_name)
        end

        def process_methods(nodes)
          public_methods = RuboCopMethodOrder::PublicMethodCollection.new
          private_methods = RuboCopMethodOrder::MethodCollection.new
          protected_methods = RuboCopMethodOrder::MethodCollection.new
          class_methods = RuboCopMethodOrder::MethodCollection.new

          mode = :public
          method_groups = nodes.each_with_object({}) do |obj, memo|
            if obj.type == :def
              memo[mode] = [] if memo[mode].nil?
              memo[mode] << obj if enabled_at_line?(obj)
            elsif obj.type == :defs
              memo[:class] = [] if memo[:class].nil?
              memo[:class] << obj if enabled_at_line?(obj)
            end

            mode = obj.method_name if scope_change_node?(obj)
          end

          class_method_nodes = method_groups[:class] || []
          class_method_nodes.each { |def_node| class_methods.push(def_node.method_name) }
          class_method_nodes.each { |def_node| check_node(class_methods, def_node) }

          public_method_nodes = method_groups[:public] || []
          public_method_nodes.each { |def_node| public_methods.push(def_node.method_name) }
          public_method_nodes.each { |def_node| check_node(public_methods, def_node) }

          private_method_nodes = method_groups[:private] || []
          private_method_nodes.each { |def_node| private_methods.push(def_node.method_name) }
          private_method_nodes.each { |def_node| check_node(private_methods, def_node) }

          protected_method_nodes = method_groups[:protected] || []
          protected_method_nodes.each { |def_node| protected_methods.push(def_node.method_name) }
          protected_method_nodes.each { |def_node| check_node(protected_methods, def_node) }
        end

        def scope_change_node?(node)
          node.type == :send && %i[private protected].include?(node.method_name)
        end
      end
    end
  end
end
