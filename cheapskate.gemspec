# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cheapskate/version'

Gem::Specification.new do |spec|
  spec.name          = "cheapskate"
  spec.version       = Cheapskate::VERSION
  spec.authors       = ["Dan Tao"]
  spec.email         = ["daniel.tao@gmail.com"]
  spec.description   = %q{Seamlessly jump to a separate domain for HTTPS login and then back}
  spec.summary       = %q{HTTPS login from a separate domain}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "randy"
end
