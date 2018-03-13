# frozen_string_literal: true

require 'test_helper'

# Unit tests for the MethodOrder RuboCop Cop
class RuboCopMethodOrderTest < Minitest::Test
  include RuboCopHelpers

  def setup
    config = RuboCop::Config.new
    @cop = RuboCop::Cop::Style::MethodOrder.new(config)
  end

  def test_good_model
    investigate(@cop, fixture_file('good_full_class.rb'))
    assert_empty @cop.offenses.map(&:message)
  end

  def test_method_before_initialize
    investigate(@cop, fixture_file('bad_method_before_initialize.rb'))

    assert_equal 2, @cop.offenses.count
    assert_equal \
      'Method `apple` should come after the method `initialize`.',
      @cop.offenses.first.message
    assert_equal \
      'Method `initialize` should come before the method `apple`.',
      @cop.offenses.last.message
  end

  def test_bad_method_order
    investigate(@cop, fixture_file('bad_public_method_order.rb'))

    assert_equal 2, @cop.offenses.count
    assert_equal \
      'Method `hello` should come after the method `apple`.',
      @cop.offenses.first.message
    assert_equal \
      'Method `apple` should come before the method `hello`.',
      @cop.offenses.last.message
  end
end
