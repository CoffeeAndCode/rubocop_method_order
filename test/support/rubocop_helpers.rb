# frozen_string_literal: true

require 'pathname'
require 'rubocop'

# Helpful methods for testing RuboCop Cops
module RuboCopHelpers
  def fixture_file(filepath)
    IO.read(Pathname.new("#{__dir__}/../fixtures/files/#{filepath}"))
  end

  def autocorrect(cop, src)
    source = RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f)
    cop.instance_variable_get(:@options)[:auto_correct] = true
    investigate(cop, src)

    corrector =
      RuboCop::Cop::Corrector.new(source.buffer, cop.corrections)
    corrector.rewrite
  end

  def investigate(cop, src)
    source = RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(source)
    commissioner
  end
end
