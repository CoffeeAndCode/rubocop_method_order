# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure MethodCollection functionality for library is valid
  class MethodCollectionTest < Minitest::Test
    def test_methods_attribute_is_an_array
      assert_kind_of Array, MethodCollection.new.methods
    end

    def test_can_push_new_method_symbol_to_collection_and_return_self
      collection = MethodCollection.new

      assert_kind_of MethodCollection, collection.push(:method_name)
      assert_includes collection.methods, :method_name
    end

    def test_has_ability_to_return_methods_in_order
      collection = MethodCollection.new
      collection.push(:method_name)
      collection.push(:another_method_name)

      assert_equal %i[
        another_method_name
        method_name
      ], collection.ordered_methods
    end
  end
end
