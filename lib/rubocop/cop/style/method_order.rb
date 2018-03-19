# frozen_string_literal: true

require 'rubocop'
require_relative '../../../rubocop_method_order/method_collector'

module RuboCop
  module Cop
    module Style
      # This cop enforces methods to be sorted alphabetically within the context
      # of their scope and permission level such as `private` or `protected`.
      # The method `initialize` is given special treatment by being required to
      # be listed first in the context of a class if it's a public method.
      #
      # @example
      #
      #   # bad
      #
      #   # `foo` should be listed after `bar`. Both methods will actually
      #   # show a linter error with a message indicating if they should show
      #   # before or after the comparision method. The private methods will
      #   # also each show errors in relation to each other.
      #   class ExampleClass
      #     def foo
      #     end
      #
      #     def bar
      #     end
      #
      #     private
      #
      #     def private_method
      #     end
      #
      #     def another_method
      #     end
      #   end
      #
      # @example
      #
      #   # bad
      #
      #   # Works on modules too.
      #   module ExampleModule
      #     def foo
      #     end
      #
      #     def bar
      #     end
      #   end
      #
      # @example
      #
      #   # bad
      #
      #   # As well as top level ruby methods in a file.
      #   def foo
      #   end
      #
      #   def bar
      #   end
      #
      # @example
      #
      #   # good
      #
      #   class ExampleClass
      #     def bar
      #     end
      #
      #     def foo
      #     end
      #
      #     private
      #
      #     def another_method
      #     end
      #
      #     def private_method
      #     end
      #   end
      #
      # @example
      #
      #   # good
      #
      #   module ExampleModule
      #     def bar
      #     end
      #
      #     def foo
      #     end
      #   end
      #
      # @example
      #
      #   # good
      #
      #   def bar
      #   end
      #
      #   def foo
      #   end
      class MethodOrder < Cop
        include RangeHelp

        MSG = 'Method `%<method>s` should come %<direction>s the method `%<other_method>s`.'

        # def autocorrect(node)
        #   lambda do |corrector|
        #     range = range_by_whole_lines_including_method_comments(node.source_range)
        #     corrector.replace(range, 'FIX ME!')
        #   end
        # end

        def investigate(_processed_source)
          @method_collector = RuboCopMethodOrder::MethodCollector.new(
            should_skip_method: ->(node) { !cop_enabled_for_node?(node) }
          )
          @offenses_checked = false
        end

        # NOTE: Change this if cops get a callback method for running validations
        #       after the on_* methods have been executed.
        def offenses(*args)
          unless @offenses_checked
            @offenses_checked = true
            check_nodes
          end

          super(*args)
        end

        def on_class(node)
          @method_collector.collect_nodes_from_class(node)
        end

        def on_def(node)
          @method_collector.collect(node)
        end
        alias on_defs on_def

        def on_module(node)
          @method_collector.collect_nodes_from_module(node)
        end

        private

        def check_nodes
          @method_collector.nodes_by_scope.values.each do |method_collection|
            method_collection.offenses.each do |offense|
              add_offense(offense[:node], location: :expression, message: message(
                offense[:node].method_name,
                offense[:other_node].method_name,
                offense[:direction]
              ))
            end
          end
        end

        def cop_enabled_for_node?(node)
          processed_source.comment_config.cop_enabled_at_line?(self, node.first_line)
        end

        def message(method_name, following_method_name, direction)
          format(MSG,
                 direction: direction,
                 method: method_name,
                 other_method: following_method_name)
        end

        # Coming soon...
        # def range_by_whole_lines_including_method_comments(range)
        #   buffer = @processed_source.buffer

        #   begin_pos = range.begin_pos
        #   begin_offset = range.column
        #   begin_of_first_line = begin_pos - begin_offset

        #   line_number = range.first_line
        #   loop do
        #     line_number -= 1
        #     source_line = buffer.source_line(line_number)
        #     break unless source_line.match?(/\s+#/)

        #     begin_of_first_line -= source_line.length
        #   end

        #   last_line = buffer.source_line(range.last_line)
        #   end_pos = range.end_pos
        #   end_offset = last_line.length - range.last_column
        #   end_offset += 1
        #   end_of_last_line = end_pos + end_offset

        #   Parser::Source::Range.new(buffer, begin_of_first_line, end_of_last_line)
        # end
      end
    end
  end
end
