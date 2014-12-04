# -*- encoding: utf-8 -*-
require File.expand_path('lib/shoes/version')

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = Shoes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{Shoes is the best little GUI toolkit for Ruby. Shoes runs on JRuby only for now.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple. Shoes runs on JRuby only for now.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "shoes-core", Shoes::VERSION
  s.add_dependency "shoes-swt",  Shoes::VERSION
  s.add_dependency "shoes-manual", "~> 4.0.0", ">= 4.0.0"

  # Strong chance all three of these should be someone else's dependency
  s.add_dependency "furoshiki", "~> 0.1", ">=0.1.2"      # For packaging

  # shoes executables are actually installed from shoes-core
end
