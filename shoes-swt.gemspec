# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shoes/swt/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "shoes-swt"
  s.version     = Shoes::Swt::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{A JRuby and Swt backend for Shoes, the best little GUI toolkit for Ruby.}
  s.description = %q{A JRuby and Swt backend for Shoes, the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple.}
  s.license     = 'MIT'

  s.files         = `git ls-files -- lib/shoes/swt`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "swt", "~>0.18"
  s.add_dependency "furoshiki", ">=0.1.2" # For packaging
  s.add_dependency "after_do", "~>0.3"
end
