# -*- encoding: utf-8 -*-
require_relative 'lib/shoes/swt/version'
require_relative 'manifests/shoes-swt'

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

  s.files         = ShoesSwtManifest.files
  s.test_files    = ShoesSwtManifest.test_files
  s.require_paths = ["lib"]

  s.add_dependency "swt", "~>4.4"
  s.add_dependency "after_do", "~>0.3"
  s.add_dependency "shoes-dsl", Shoes::Swt::VERSION
  s.add_dependency "furoshiki", "~>0.2.0" # For packaging

  s.executables   = ['shoes-swt']
end
