# -*- encoding: utf-8 -*-
# frozen_string_literal: true
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@lists.mvmanila.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = 'Shoes is the best little GUI toolkit for Ruby. Shoes runs on JRuby only for now.'
  s.description = 'Shoes is the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple. Shoes runs on JRuby only for now.'
  s.license     = 'MIT'

  s.files = Dir[
    "LICENSE", "README.md",
    "lib/**/*",
    "ext/install/**/*",
    "samples/*",
    "samples/lib/*",
    "samples/potato_chopping/*",
    "samples/sounds/*",
  ]

  s.add_dependency "shoes-core", version
  s.add_dependency "shoes-swt",  version
  s.add_dependency "shoes-manual", "~> 4.0.0", ">= 4.0.0"

  # Curious why we don't install shoes? See ext/Rakefile for the nitty-gritty.
  s.executables   = ['shoes-stub']
  s.extensions    = ['ext/install/Rakefile']
end
