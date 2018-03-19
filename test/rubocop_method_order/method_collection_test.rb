# frozen_string_literal: true
# # frozen_string_literal: true

# require 'test_helper'

# module RuboCopMethodOrder
#   # Ensure MethodCollection functionality for library is valid
#   class MethodCollectionTest < Minitest::Test
#     def test_methods_attribute_is_an_array
#       assert_kind_of Array, MethodCollection.new.methods
#     end

#     def test_can_push_new_method_symbol_to_collection_and_return_self
#       collection = MethodCollection.new

#       assert_kind_of MethodCollection, collection.push(:method_name)
#       assert_includes collection.methods, :method_name
#     end

#     def test_has_ability_to_return_methods_in_order
#       collection = MethodCollection.new
#       collection.push(:method_name)
#       collection.push(:another_method)

#       assert_equal %i[
#         another_method
#         method_name
#       ], collection.ordered_methods
#     end

#     def test_method_order_correct_is_true_if_index_is_correct_for_method
#       collection = MethodCollection.new
#       collection.push(:another_method)
#       collection.push(:method_name)

#       assert collection.method_order_correct?(:method_name)
#       assert collection.method_order_correct?(:another_method)
#     end

#     def test_method_order_correct_is_false_if_index_is_not_correct_for_method
#       collection = MethodCollection.new
#       collection.push(:method_name)
#       collection.push(:another_method)

#       refute collection.method_order_correct?(:method_name)
#       refute collection.method_order_correct?(:another_method)
#     end

#     def test_expected_method_index_will_return_ordered_index_of_method
#       collection = MethodCollection.new
#       collection.push(:method_name)
#       collection.push(:another_method)

#       assert_equal 1, collection.expected_method_index(:method_name)
#       assert_equal 0, collection.expected_method_index(:another_method)
#     end

#     def test_next_method_name_will_return_method_after_passed_after_ordering
#       collection = MethodCollection.new
#       collection.push(:method_name)
#       collection.push(:another_method)

#       assert_equal :method_name, collection.next_method_name(:another_method)
#     end

#     def test_next_method_name_will_return_nil_if_no_methods
#       collection = MethodCollection.new

#       assert_nil collection.next_method_name(:another_method)
#     end

#     def test_next_method_name_will_return_nil_if_no_following_method
#       collection = MethodCollection.new
#       collection.push(:method_name)

#       assert_nil collection.next_method_name(:method_name)
#     end

#     def test_previous_method_name_will_return_method_before_passed
#       collection = MethodCollection.new
#       collection.push(:method_name)
#       collection.push(:another_method)

#       assert_equal :another_method,
#                    collection.previous_method_name(:method_name)
#     end

#     def test_previous_method_name_will_return_nil_if_no_methods
#       collection = MethodCollection.new

#       assert_nil collection.previous_method_name(:another_method)
#     end

#     def test_previous_method_name_will_return_nil_if_no_previous_method
#       collection = MethodCollection.new
#       collection.push(:method_name)

#       assert_nil collection.previous_method_name(:method_name)
#     end
#   end
# end
