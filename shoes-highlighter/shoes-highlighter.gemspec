# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'shoes/highlighter/version'
require File.expand_path(File.join(__FILE__, "..", "..", "manifests", "shoes-highlighter"))

Gem::Specification.new do |s|
  s.name          = "shoes-highlighter"
  s.version     = Shoes::Highlighter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Team Shoes"]
  s.email       = ["shoes@librelist.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = 'A syntax highlighting library used by Shoes'
  s.description = 'A syntax highlighting library used by Shoes. Originally extracted from Hackety-Hack.'
  s.license     = 'MIT'

  s.files         = ShoesHighlighterManifest.files
  s.test_files    = ShoesHighlighterManifest.test_files
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
end
