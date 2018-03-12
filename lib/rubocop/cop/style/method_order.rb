# frozen_string_literal: true

require 'rubocop'

module RuboCop
  module Cop
    module Style
      class MethodOrder < Cop
        MSG = 'Method `%<method>s` should come %<direction>s the method `%<other_method>s`.'.freeze
        VERSION = '0.1.0'.freeze

        def on_begin(node)
          if node.parent&.type == :class

            mode = :public

            method_groups = node.children.reduce({}) do |memo, obj|
              if obj.type == :def
                memo[mode] = [] if memo[mode].nil?
                memo[mode] << obj
              end

              if obj.type == :send
                mode = obj.method_name
              end

              memo
            end

            method_nodes = method_groups[:public].select { |n| n.type == :def }
            method_nodes.each { |def_node| @public_methods.push(def_node.method_name) }
            method_nodes.each { |def_node| check_node(def_node) }
          end
        end

        def on_class(node)
          @public_methods = PublicMethodCollection.new
        end

        private

        def check_node(node)
          method_index = @public_methods.methods.index(node.method_name)
          expected_method_index = @public_methods.ordered_methods.index(node.method_name)

          if expected_method_index != method_index
            direction = 'before'
            other_method = @public_methods.ordered_methods[expected_method_index + 1]

            if expected_method_index > method_index
              direction = 'after'
              other_method = @public_methods.ordered_methods[expected_method_index - 1]
            end

            add_offense(node, location: :expression, message: message(
              node.method_name,
              other_method,
              direction))
          end
        end

        def message(method_name, following_method_name, direction)
          format(MSG, direction: direction, method: method_name, other_method: following_method_name)
        end

        class PublicMethodCollection
          def initialize
            @initialize_found = false
            @all_methods = []
          end

          def methods
            @all_methods
          end

          def ordered_methods
            if @initialize_found
              [:initialize] + (@all_methods - [:initialize]).sort
            else
              @all_methods.sort
            end
          end

          def push(method_name)
            @initialize_found = true if method_name == :initialize
            @all_methods << method_name
            self
          end
        end
      end
    end
  end
end
