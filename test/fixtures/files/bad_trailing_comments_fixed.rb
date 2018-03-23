class MethodsWithTrailingComments
  def apple
  end

  # This method is pretty great.
  #
  # rubocop:disable SomeRule
  def bear
  end
  # rubocop:enable SomeRule
end
