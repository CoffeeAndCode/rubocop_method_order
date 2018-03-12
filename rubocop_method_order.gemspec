
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/cop/style/method_order'

Gem::Specification.new do |spec|
  spec.name          = "rubocop_method_order"
  spec.version       = RuboCop::Cop::Style::MethodOrder::VERSION
  spec.authors       = ["Jonathan Knapp"]
  spec.email         = ["jon@coffeeandcode.com"]

  spec.summary       = "Provide order to your Ruby classes by expecting methods to be listed alphabetically by permission group (public, private, protected)."
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  spec.add_dependency "rubocop", "~> 0.53"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.0"
end
