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
      #   # `bar` should be listed before `foo`. The method `bar` will show
      #   # a linter error with a message indicating which method is should show
      #   # before. The private method `another_method` will also an error
      #   # saying it should be before `private_method`.
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
      class MethodOrder < Cop # rubocop:disable Metrics/ClassLength
        include RangeHelp

        MSG = 'Methods should be sorted in alphabetical order within their section' \
              ' of the code. Method `%<method>s` should come before `%<previous_method>s`.'

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity,
        # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
        def autocorrect(_node)
          lambda do |corrector|
            @method_collector.nodes_by_scope.values.each do |method_collection|
              next if @autocorrected_method_collections.include?(method_collection)

              @autocorrected_method_collections << method_collection
              method_collection.replacements.values.each do |replacement_collection|
                replacement_collection.each do |node_to_move, node_to_replace|
                  next if @autocorrected_nodes.include?(node_to_move)

                  @autocorrected_nodes << node_to_move
                  node_source = range_with_method_comments(node_to_move).source
                  replacement_range = range_with_method_comments(node_to_replace)

                  if node_source.end_with?("\n") && !replacement_range.source.end_with?("\n")
                    corrector.replace(replacement_range, node_source.chomp("\n"))
                  elsif !node_source.end_with?("\n") && replacement_range.source.end_with?("\n")
                    corrector.replace(replacement_range, node_source + "\n")
                  else
                    corrector.replace(replacement_range, node_source)
                  end
                end
              end
            end
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity,
        # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity

        def investigate(_processed_source)
          @autocorrected_method_collections = []
          @autocorrected_nodes = []
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

        def begin_pos_with_comments(node)
          range = node.source_range
          begin_of_first_line = range.begin_pos - range.column
          line_number = range.first_line

          loop do
            line_number -= 1
            source_line = @processed_source.buffer.source_line(line_number)
            break unless source_line.match?(/\s*#/)

            begin_of_first_line -= source_line.length + 1 # account for \n char
          end
          begin_of_first_line
        end

        def check_nodes
          @method_collector.nodes_by_scope.values.each do |method_collection|
            method_collection.offenses.each do |offense|
              add_offense(offense[:node], location: :expression, message: message(
                offense[:node].method_name,
                offense[:other_node].method_name
              ))
            end
          end
        end

        def cop_enabled_for_node?(node)
          processed_source.comment_config.cop_enabled_at_line?(self, node.first_line)
        end

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def end_pos_with_comments(node)
          range = node.source_range
          last_line = @processed_source.buffer.source_line(range.last_line)
          end_of_last_line = range.end_pos + last_line.length - range.last_column
          line_number = node.source_range.last_line

          if line_number != @processed_source.lines.count
            end_of_last_line += 1 # account for newline
          end

          loop do
            line_number += 1
            break if line_number > @processed_source.lines.count
            source_line = @processed_source.buffer.source_line(line_number)
            break unless source_line.match?(/\s*#/)

            adjustment = 0
            if line_number != @processed_source.lines.count
              adjustment = 1 # account for newline
            end

            end_of_last_line += source_line.length + adjustment
          end
          end_of_last_line
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        def message(method_name, following_method_name)
          format(MSG,
                 method: method_name,
                 previous_method: following_method_name)
        end

        def range_with_method_comments(node)
          Parser::Source::Range.new(@processed_source.buffer,
                                    begin_pos_with_comments(node),
                                    end_pos_with_comments(node))
        end
      end
    end
  end
end
