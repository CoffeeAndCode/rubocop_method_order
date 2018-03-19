# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure MethodNodeCollection functionality for library is valid
  class MethodNodeCollectionTest < Minitest::Test
    def test_methods_attribute_is_an_array
      assert_kind_of Array, MethodNodeCollection.new.methods
    end

    def test_can_push_new_method_symbol_to_collection_and_return_self
      collection = MethodNodeCollection.new

      method_one_node = OpenStruct.new(method_name: :method_one)
      assert_kind_of MethodNodeCollection, collection.push(method_one_node)
      assert_includes collection.nodes, method_one_node
    end

    def test_will_report_no_offenses_if_methods_added_in_alphabetical_order
      collection = MethodNodeCollection.new

      method_one_node = OpenStruct.new(method_name: :method_one)
      method_two_node = OpenStruct.new(method_name: :method_two)

      collection.push(method_one_node)
      collection.push(method_two_node)

      assert_empty collection.offenses
    end

    def test_will_report_offenses_if_methods_added_in_non_alphabetical_order
      collection = MethodNodeCollection.new

      method_one_node = OpenStruct.new(method_name: :method_one)
      method_two_node = OpenStruct.new(method_name: :method_two)
      collection.push(method_two_node)
      collection.push(method_one_node)

      assert_equal [
        {
          direction: 'after',
          node: method_two_node,
          other_node: method_one_node
        },
        {
          direction: 'before',
          node: method_one_node,
          other_node: method_two_node
        }
      ], collection.offenses
    end
  end
end
