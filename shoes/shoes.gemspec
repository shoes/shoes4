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

  # Strong chance all three of these should be someone else's dependency
  s.add_dependency "shoes-highlighter", "~> 1.0", ">= 1.0.0"
  s.add_dependency "nokogiri", "~> 1.6.4.1", ">=1.6.4.1" # For converting the manual to HTML

  # shoes executables are actually installed from shoes-core
end
