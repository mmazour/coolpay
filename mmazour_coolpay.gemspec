# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coolpay/version'

Gem::Specification.new do |spec|
  spec.name          = 'coolpay'
  spec.version       = ::Coolpay::VERSION
  spec.authors       = ['Michael Mazour']
  spec.email         = ['michaelmazour@gmail.com']

  spec.summary       = 'Coolpay is a wrapper for the Coolpay API.'
  spec.homepage      = 'https://github.com/mmazour/coolpay'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('lib/**/*.rb') + %w[README.md TODO Rakefile]
  spec.test_files    = Dir.glob('test/**/*')

  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.5' # oldest stable at time of writing

  spec.add_dependency 'rest-client', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.66.0'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.5'
end
