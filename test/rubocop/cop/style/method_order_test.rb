# frozen_string_literal: true

require 'test_helper'

# Unit tests for the MethodOrder RuboCop Cop
class RuboCopMethodOrderTest < Minitest::Test
  include RuboCopHelpers

  def error_message(method_name, previous_method_name)
    format(RuboCop::Cop::Style::MethodOrder::MSG,
           method: method_name,
           previous_method: previous_method_name)
  end

  def setup
    config = RuboCop::Config.new
    @cop = RuboCop::Cop::Style::MethodOrder.new(config)
  end

  def test_good_one_method_class
    investigate(@cop, fixture_file('good_one_method_class.rb'))
    assert_empty @cop.offenses.map(&:message)
  end

  def test_good_model
    investigate(@cop, fixture_file('good_full_class.rb'))
    assert_empty @cop.offenses.map(&:message)
  end

  def test_bad_method_before_initialize
    investigate(@cop, fixture_file('bad_method_before_initialize.rb'))

    assert_equal 1, @cop.offenses.count
    assert_equal error_message('initialize', 'apple'),
                 @cop.offenses.first.message
  end

  def test_autocorrect_bad_method_before_initialize
    assert_equal fixture_file('bad_method_before_initialize_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_method_before_initialize.rb'))
  end

  def test_bad_method_order
    investigate(@cop, fixture_file('bad_public_method_order.rb'))

    assert_equal 1, @cop.offenses.count
    assert_equal error_message('apple', 'hello'),
                 @cop.offenses.first.message
  end

  def test_autocorrect_bad_public_method_order
    assert_equal fixture_file('bad_public_method_order_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_public_method_order.rb'))
  end

  def test_good_methods_with_comments
    investigate(@cop, fixture_file('good_methods_with_comments.rb'))
    assert_equal 0, @cop.offenses.count
  end

  def test_good_module
    investigate(@cop, fixture_file('good_module.rb'))
    assert_equal 0, @cop.offenses.count
  end

  def test_bad_module_method_order
    investigate(@cop, fixture_file('bad_module_method_order.rb'))

    assert_equal 3, @cop.offenses.count
    assert_equal [
      error_message('find', 'where'),
      error_message('apple', 'hello'),
      error_message('initialize', 'hello')
    ], @cop.offenses.map(&:message)
  end

  def test_autocorrect_bad_module_method_order
    assert_equal fixture_file('bad_module_method_order_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_module_method_order.rb'))
  end

  def test_basic_ruby_file
    investigate(@cop, fixture_file('good_basic_ruby_file.rb'))
    assert_equal 0, @cop.offenses.count
  end

  def test_bad_basic_ruby_file
    investigate(@cop, fixture_file('bad_basic_ruby_file.rb'))

    assert_equal 2, @cop.offenses.count
    assert_equal [
      error_message('apple', 'initialize'),
      error_message('hello', 'initialize')
    ], @cop.offenses.map(&:message)
  end

  def test_autocorrect_bad_basic_ruby_file
    assert_equal fixture_file('bad_basic_ruby_file_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_basic_ruby_file.rb'))
  end

  def test_autocorrect_bad_class_with_method_content
    assert_equal fixture_file('bad_class_with_method_content_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_class_with_method_content.rb'))
  end

  def test_autocorrect_bad_basic_ruby_file_with_no_ending_newline
    assert_equal fixture_file('bad_ruby_file_without_newline_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_ruby_file_without_newline.rb'))
  end
end
