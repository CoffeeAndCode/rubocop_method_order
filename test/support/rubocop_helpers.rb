# frozen_string_literal: true

require 'pathname'
require 'rubocop'

# Helpful methods for testing RuboCop Cops
module RuboCopHelpers
  def fixture_file(filepath)
    IO.read(Pathname.new("#{__dir__}/../fixtures/files/#{filepath}"))
  end

  def investigate(cop, src, filename = nil)
    source = RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f, filename)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(source)
    commissioner
  end
end
