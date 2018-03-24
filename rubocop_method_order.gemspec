
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop_method_order/version'

Gem::Specification.new do |spec|
  spec.name = 'rubocop_method_order'
  spec.version = RuboCopMethodOrder.gem_version
  spec.license = 'MIT'
  spec.author = 'Jonathan Knapp'
  spec.email = 'jon@coffeeandcode.com'

  spec.summary = 'A Rubocop extension that provides order to your Ruby files ' \
                 'by expecting methods to be listed alphabetically.'
  spec.homepage = 'https://github.com/CoffeeAndCode/rubocop_method_order'
  spec.metadata = { 'source_code_uri' => 'https://github.com/CoffeeAndCode/rubocop_method_order' }

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(checksums|test)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |file| File.basename(file) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.3.0'
  spec.cert_chain = ['certs/coffeeandcode.pem']

  if $PROGRAM_NAME.end_with?('gem')
    spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end

  spec.add_runtime_dependency 'rubocop', '~> 0.53'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 12.3'
end
