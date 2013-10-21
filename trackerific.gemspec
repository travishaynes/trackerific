# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trackerific/version'

Gem::Specification.new do |spec|
  spec.name          = "trackerific"
  spec.version       = Trackerific::VERSION
  spec.authors       = ["Travis Haynes"]
  spec.email         = ["travis.j.haynes@gmail.com"]
  spec.description   = %q{Package tracking made easy. Currently supported services include FedEx, UPS, and USPS.}
  spec.summary       = %q{Package tracking made easy.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty', '>= 0.12.0'
  spec.add_dependency 'savon', '~> 2.3.0'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'builder'

  spec.add_development_dependency 'bundler', '>= 1.3.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.6.0'
  spec.add_development_dependency 'fakeweb', '~> 1.3.0'
  spec.add_development_dependency 'coveralls', '~> 0.7.0'
end
