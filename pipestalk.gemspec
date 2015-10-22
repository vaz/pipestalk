# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pipestalk/version'

Gem::Specification.new do |spec|
  spec.name          = "pipestalk"
  spec.version       = Pipestalk::VERSION
  spec.authors       = ["V"]
  spec.email         = ["v@tryptid.com"]
  spec.summary       = %q{A 'pipes and filters' gem built in beanstalkd}
  spec.description   = spec.summary
  spec.homepage      = "http://github.com/vaz/pipestalk"
  spec.license       = "MIT"

  spec.files         = Dir['LICENSE.txt', 'README.md',
                           'pipestalk.gemspec', 'lib/**/*', 'spec/**/*']

  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry'

  spec.add_dependency 'activesupport', '~> 4.2.0'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'beaneater', '~> 0.3'
  spec.add_dependency 'hashie', '~> 3.3.1'
end
