# -*- encoding: utf-8 -*-
require File.expand_path('lib/shoes/package/version')

Gem::Specification.new do |s|
  s.name        = "shoes-package"
  s.version     = Shoes::Package::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{Application packaging for Shoes, the best little GUI toolkit for Ruby.}
  s.description = %q{Application packaging for Shoes, the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "shoes-core", Shoes::Package::VERSION
  s.add_dependency "furoshiki", "~> 0.3.0"
end
