require "test_helper"

class RuboCopMethodOrderTest < Minitest::Test
  include RuboCopHelpers

  def setup
    config = RuboCop::Config.new
    @cop = RuboCop::Cop::Style::MethodOrder.new(config)
  end

  def test_that_it_has_a_version_number
    refute_nil ::RuboCop::Cop::Style::MethodOrder::VERSION
  end

  def test_good_model
    investigate(@cop, <<-RUBY)
      class CustomClass
        def self.find
        end

        def self.where
        end

        def initialize
        end

        def apple
        end

        def hello
        end

        class NestedClass
          def another_method
          end
        end

        private

        def better_private_method
        end

        def super_private
        end

        protected

        def better_protected_method
        end

        def super_protected
        end
      end
    RUBY

    assert_empty @cop.offenses.map(&:message)
  end

  def test_method_before_initialize
    investigate(@cop, <<-RUBY)
      class CustomClass
        def apple
        end

        def initialize
        end

        def hello
        end
      end
    RUBY

    assert_equal 2, @cop.offenses.count
    assert_equal "Method `apple` should come after the method `initialize`.", @cop.offenses.first.message
    assert_equal "Method `initialize` should come before the method `apple`.", @cop.offenses.last.message
  end

  def test_bad_method_order
    investigate(@cop, <<-RUBY)
      class CustomClass
        def initialize
        end

        def hello
        end

        def apple
        end
      end
    RUBY

    assert_equal 2, @cop.offenses.count
    assert_equal "Method `hello` should come after the method `apple`.", @cop.offenses.first.message
    assert_equal "Method `apple` should come before the method `hello`.", @cop.offenses.last.message
  end
end
