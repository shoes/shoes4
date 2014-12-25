# -*- encoding: utf-8 -*-
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{Shoes is the best little GUI toolkit for Ruby. Shoes runs on JRuby only for now.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby. Shoes makes building for Mac, Windows, and Linux super simple. Shoes runs on JRuby only for now.}
  s.license     = 'MIT'

  s.files         = ["LICENSE", "README.md"]

  s.add_dependency "shoes-core", version
  s.add_dependency "shoes-swt",  version
  s.add_dependency "shoes-manual", "~> 4.0.0", ">= 4.0.0"

  # shoes executables are actually installed from shoes-core
end
