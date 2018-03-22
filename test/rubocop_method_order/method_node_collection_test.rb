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
          node: method_one_node,
          other_node: method_two_node
        }
      ], collection.offenses
    end

    def test_will_return_replacements_used_for_autocorrect
      collection = MethodNodeCollection.new

      apple = OpenStruct.new(method_name: :apple)
      bear = OpenStruct.new(method_name: :bear)
      cat = OpenStruct.new(method_name: :cat)
      collection.push(bear)
      collection.push(apple)
      collection.push(cat)

      expected = {}
      expected[apple] = {
        apple => bear,
        bear => apple
      }
      expected[bear] = {
        bear => apple,
        apple => bear
      }
      assert_equal expected, collection.replacements
    end

    def test_will_return_no_replacements_if_order_is_correct
      collection = MethodNodeCollection.new

      apple = OpenStruct.new(method_name: :apple)
      bear = OpenStruct.new(method_name: :bear)
      cat = OpenStruct.new(method_name: :cat)
      collection.push(apple)
      collection.push(bear)
      collection.push(cat)

      assert_equal({}, collection.replacements)
    end

    # rubocop:disable Metrics/AbcSize
    def test_will_handle_more_complicated_ordering_situations
      collection = MethodNodeCollection.new

      create = OpenStruct.new(method_name: :create)
      destroy = OpenStruct.new(method_name: :destroy)
      edit = OpenStruct.new(method_name: :edit)
      index = OpenStruct.new(method_name: :index)
      neue = OpenStruct.new(method_name: :new)
      update = OpenStruct.new(method_name: :update)

      collection.push(index)
      collection.push(neue)
      collection.push(edit)
      collection.push(create)
      collection.push(update)
      collection.push(destroy)

      expected = {}
      expected[index] = {
        create => index,
        index => create
      }
      expected[neue] = {
        neue => update,
        update => destroy
      }
      expected[create] = {
        create => index,
        index => create
      }
      expected[update] = {
        destroy => neue,
        update => destroy
      }
      expected[destroy] = {
        destroy => neue,
        neue => update
      }
      assert_equal(expected, collection.replacements)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
