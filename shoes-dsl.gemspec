# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shoes/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "shoes-dsl"
  s.version     = Shoes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{The best little DSL for the best little GUI toolkit for Ruby.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple. This is the DSL for writing your app. You'll need a backend to run it.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n").delete_if { |path| path =~ %r{^lib/shoes/swt|spec/swt_shoes|lib/shoes/cli.rb} }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Curious why we don't install shoes? See ext/Rakefile for the nitty-gritty.
  s.executables   = ['shoes-stub', 'ruby-shoes']
  s.extensions    = ['ext/install/Rakefile']

  s.add_dependency "nokogiri" # For converting the manual to HTML

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"

  s.add_development_dependency "rspec", "~>2.99.0.rc1"
  s.add_development_dependency "rspec-its", "~>1.0.1"
  s.add_development_dependency "rake"

  s.add_development_dependency "yard"
  s.add_development_dependency "kramdown"
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'jruby-lint'
  s.add_development_dependency 'webmock'
end
