# frozen_string_literal: true
# # frozen_string_literal: true

# require 'test_helper'

# module RuboCopMethodOrder
#   # Ensure MethodCollector functionality for library is valid
#   class MethodCollectorTest < Minitest::Test
#     def test_maintains_a_collection_of_passed_method_nodes
#       assert_kind_of Array, MethodCollector.new.all_method_nodes
#     end

#     def test_can_collect_method_nodes
#       collector = MethodCollector.new
#       def_node = 'DEF NODE 1'
#       collector.collect def_node
#       assert_includes collector.all_method_nodes, def_node
#     end

#     def test_will_not_collect_the_same_node_twice
#       collector = MethodCollector.new
#       def_node = 'DEF NODE 1'
#       collector.collect def_node
#       collector.collect def_node
#       assert_equal [def_node], collector.all_method_nodes
#     end

#     def test_can_collect_nodes_from_class_ast_node
#       class_node = OpenStruct.new(child_nodes: [])
#       collector = MethodCollector.new
#       collector.collect_nodes_from_class(class_node)
#       assert_equal [], collector.all_method_nodes
#     end

#     def test_can_collect_nodes_from_module_ast_node
#       module_node = OpenStruct.new(child_nodes: [])
#       collector = MethodCollector.new
#       collector.collect_nodes_from_module(module_node)
#       assert_equal [], collector.all_method_nodes
#     end
#   end
# end
