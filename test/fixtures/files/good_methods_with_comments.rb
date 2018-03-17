class CustomClass
  include RuboCopHelpers

  def self.where # rubocop:disable Style/MethodOrder
  end

  def self.find
  end

  def apple # rubocop:disable Style/MethodOrder
  end

  # rubocop:disable Style/MethodOrder
  def hello
  end
  # rubocop:enable Style/MethodOrder

  def initialize
  end
end
