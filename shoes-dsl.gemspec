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

  s.files         = `git ls-files`.split("\n").delete_if { |path| path =~ %r{^lib/shoes/swt|spec/swt_shoes} }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # Curious why we don't install shoes? See ext/Rakefile for the nitty-gritty.
  s.executables   = ['shoes-stub', 'ruby-shoes']
  s.extensions    = ['ext/install/Rakefile']
end
