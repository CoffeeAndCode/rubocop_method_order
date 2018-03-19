# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure PublicMethodNodeCollection functionality for library is valid
  class PublicMethodNodeCollectionTest < Minitest::Test
    def test_methods_attribute_is_an_array
      assert_kind_of Array, PublicMethodNodeCollection.new.methods
    end

    def test_can_push_new_method_symbol_to_collection_and_return_self
      collection = PublicMethodNodeCollection.new

      method_one_node = OpenStruct.new(method_name: :method_one)
      assert_kind_of PublicMethodNodeCollection, collection.push(method_one_node)
      assert_includes collection.nodes, method_one_node
    end

    def test_will_report_no_offenses_if_methods_added_in_alphabetical_order
      collection = PublicMethodNodeCollection.new

      initialize_node = OpenStruct.new(method_name: :initialize)
      apple_node = OpenStruct.new(method_name: :apple)
      orange_node = OpenStruct.new(method_name: :orange)

      collection.push(initialize_node)
      collection.push(apple_node)
      collection.push(orange_node)

      assert_empty collection.offenses
    end

    def test_will_report_offenses_if_methods_added_in_non_alphabetical_order
      collection = PublicMethodNodeCollection.new

      initialize_node = OpenStruct.new(method_name: :initialize)
      apple_node = OpenStruct.new(method_name: :apple)
      orange_node = OpenStruct.new(method_name: :orange)
      collection.push(apple_node)
      collection.push(initialize_node)
      collection.push(orange_node)

      assert_equal [
        {
          direction: 'after',
          node: apple_node,
          other_node: initialize_node
        },
        {
          direction: 'before',
          node: initialize_node,
          other_node: apple_node
        }
      ], collection.offenses
    end
  end
end
