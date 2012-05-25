# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "shoes/version"

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = Shoes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Klabnik", "Team Shoes"]
  s.email       = ["steve@steveklabnik.com"]
  s.homepage    = "http://github.com/shoes/shoes"
  s.summary     = %q{Shoes is the best little GUI toolkit for Ruby.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby. This gem is currently a placeholder until we properly gemfiy Shoes.}

  #s.add_development_dependency "watchr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["gemlib"]
end
