# frozen_string_literal: true

require File.expand_path('lib/shoes/core/version')

Gem::Specification.new do |s|
  s.name        = "shoes-core"
  s.version     = Shoes::Core::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@lists.mvmanila.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = 'The best little DSL for the best little GUI toolkit for Ruby.'
  s.description = "Shoes is the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple. This is the DSL for writing your app. You'll need a backend to run it."
  s.license     = 'MIT'

  s.files         = Dir["LICENSE", "README.md", "fonts/**/*", "lib/**/*", "static/**/*"]
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.executables   = ['shoes-picker']
end
