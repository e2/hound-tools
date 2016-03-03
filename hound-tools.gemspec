# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hound/tools/version'

Gem::Specification.new do |spec|
  spec.name          = 'hound-tools'
  spec.version       = Hound::Tools::VERSION
  spec.authors       = ['Cezary Baginski']
  spec.email         = ['cezary@chronomantic.net']
  spec.summary       = 'Tools for configuring and using HoundCI'
  spec.description   = 'Matches your project config to give the same errors as HoundCi'
  spec.homepage      = 'https://github.com/e2/hound-tools'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '~> 0.25'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
