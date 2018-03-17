# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure PublicMethodCollection functionality for library is valid
  class PublicMethodCollectionTest < Minitest::Test
    def test_methods_attribute_is_an_array
      assert_kind_of Array, PublicMethodCollection.new.methods
    end

    def test_can_push_new_method_symbol_to_collection_and_return_self
      collection = PublicMethodCollection.new

      assert_kind_of PublicMethodCollection, collection.push(:method_name)
      assert_includes collection.methods, :method_name
    end

    def test_has_ability_to_return_methods_in_order
      collection = PublicMethodCollection.new
      collection.push(:method_name)
      collection.push(:another_method)

      assert_equal %i[
        another_method
        method_name
      ], collection.ordered_methods
    end

    def test_will_force_initialize_method_to_be_first_when_ordered
      collection = PublicMethodCollection.new
      collection.push(:apple)
      collection.push(:initialize)

      assert_equal %i[
        initialize
        apple
      ], collection.ordered_methods
    end
  end
end
