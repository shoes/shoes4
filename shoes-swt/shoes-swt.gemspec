# -*- encoding: utf-8 -*-
require File.expand_path('lib/shoes/swt/version')

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

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "swt", "~>4.4"
  s.add_dependency "after_do", "~>0.3"
  s.add_dependency "shoes-core", Shoes::Swt::VERSION
  s.add_dependency "shoes-package", Shoes::Swt::VERSION

  s.executables   = ['shoes-swt']
end
