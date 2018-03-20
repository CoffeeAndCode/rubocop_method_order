# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure version number for library is valid
  class VersionTest < Minitest::Test
    def test_that_it_has_a_version_number
      assert_kind_of Gem::Version, RuboCopMethodOrder.gem_version
    end

    def test_that_individual_parts_are_found
      assert defined?(VERSION::MAJOR)
      assert defined?(VERSION::MINOR)
      assert defined?(VERSION::PATCH)
      assert defined?(VERSION::PRE)
      assert defined?(VERSION::STRING)
      assert_match(/^\d+\.\d+\.\d+/, VERSION::STRING)
    end
  end
end
