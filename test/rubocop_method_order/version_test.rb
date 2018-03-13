# frozen_string_literal: true

require 'test_helper'

module RuboCopMethodOrder
  # Ensure version number for library is valid
  class VersionTest < Minitest::Test
    def test_that_it_has_a_version_number
      assert_match(/\d+\.\d+\.\d+/, VERSION)
    end
  end
end
