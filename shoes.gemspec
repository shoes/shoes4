# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shoes/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = Shoes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Klabnik", "Team Shoes"]
  s.email       = ["steve@steveklabnik.com"]
  s.homepage    = "http://github.com/shoes/shoes"
  s.summary     = %q{Shoes is the best little GUI toolkit for Ruby.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "facets"
  s.add_dependency "log4jruby"
  s.add_dependency "swt"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"

  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec", "~>2.10"
  s.add_development_dependency "rake"
end
