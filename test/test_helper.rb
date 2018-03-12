$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require_relative "support/rubocop_helpers"
require "rubocop/cop/style/method_order"
require "minitest/autorun"
