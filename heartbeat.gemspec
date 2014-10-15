$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "heartbeat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "heartbeat"
  s.version     = Heartbeat::VERSION
  s.authors     = ["Envato"]
  s.email       = ["tuts-tech-notifications@envato.com"]
  s.homepage    = "http://envato.com"
  s.summary     = "Heartbeat API which can check various services (mountable plug-in)"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "bundler", ">= 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "pry"
  s.add_development_dependency "awesome_print"

  s.add_runtime_dependency "retryable"
end
