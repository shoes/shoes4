# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shoes/version', __FILE__)

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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Curious why we don't install shoes? See ext/Rakefile for the nitty-gritty.
  s.executables   = ['shoes-stub', 'ruby-shoes']
  s.extensions    = ['ext/install/Rakefile']

  s.add_dependency "swt", "~>0.18"
  s.add_dependency "furoshiki", ">=0.1.2"
  s.add_dependency "nokogiri" # For converting the manual to HTML
  s.add_dependency "after_do", "~>0.3"


  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "kramdown"
  s.add_development_dependency 'jruby-lint'

  # Tests
  s.add_development_dependency "rspec", "~>3.0.0.rc1"
  s.add_development_dependency "rspec-its", "~>1.0.1"
  s.add_development_dependency 'webmock'
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec", ">= 4.2"


  # Test Coverage
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency "codeclimate-test-reporter"
end
