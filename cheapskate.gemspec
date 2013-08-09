$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cheapskate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cheapskate"
  s.version     = Cheapskate::VERSION
  s.authors     = ["Dan Tao"]
  s.email       = ["daniel.tao@gmail.com"]
  s.homepage    = "https://github.com/dtao/cheapskate"
  s.summary     = "Seamlessly jump to a separate domain for HTTPS login and then back"
  s.description = "HTTPS login from a separate domain"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "randy"
end
