# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backtick/version'

Gem::Specification.new do |spec|
  spec.name          = "backtick"
  spec.version       = Backtick::VERSION
  spec.authors       = ["Juan Ibiapina"]
  spec.email         = ["juanibiapina@gmail.com"]

  spec.summary       = %q{Simple wrapper for running shell commands from Ruby}
  spec.homepage      = "https://github.com/globocom/backtick"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
