# frozen_string_literal: true

require 'test_helper'

# Unit tests for the MethodOrder RuboCop Cop
class RuboCopMethodOrderTest < Minitest::Test
  include RuboCopHelpers

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

    assert_equal 2, @cop.offenses.count
    assert_equal 'Method `apple` should come after the method `initialize`.',
                 @cop.offenses.first.message
    assert_equal 'Method `initialize` should come before the method `apple`.',
                 @cop.offenses.last.message
  end

  def test_autocorrect_bad_method_before_initialize
    assert_equal fixture_file('bad_method_before_initialize_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_method_before_initialize.rb'))
  end

  def test_bad_method_order
    investigate(@cop, fixture_file('bad_public_method_order.rb'))

    assert_equal 2, @cop.offenses.count
    assert_equal 'Method `hello` should come after the method `apple`.',
                 @cop.offenses.first.message
    assert_equal 'Method `apple` should come before the method `hello`.',
                 @cop.offenses.last.message
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

    assert_equal 4, @cop.offenses.count
    assert_equal [
      'Method `where` should come after the method `find`.',
      'Method `find` should come before the method `where`.',
      'Method `hello` should come after the method `apple`.',
      'Method `initialize` should come before the method `apple`.'
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

    assert_equal 3, @cop.offenses.count
    assert_equal [
      'Method `initialize` should come after the method `hello`.',
      'Method `apple` should come before the method `hello`.',
      'Method `hello` should come before the method `initialize`.'
    ], @cop.offenses.map(&:message)
  end

  def test_autocorrect_bad_basic_ruby_file
    assert_equal fixture_file('bad_basic_ruby_file_fixed.rb'),
                 autocorrect(@cop, fixture_file('bad_basic_ruby_file.rb'))
  end
end
