# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'rubocop_method_order'
require 'minitest/autorun'
require_relative 'support/rubocop_helpers'
begin
  require 'byebug'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end
