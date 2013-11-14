# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shoes/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "shoes"
  s.version     = Shoes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Klabnik", "Team Shoes"]
  s.email       = ["steve@steveklabnik.com"]
  s.homepage    = "https://github.com/shoes/shoes4"
  s.summary     = %q{Shoes is the best little GUI toolkit for Ruby.}
  s.description = %q{Shoes is the best little GUI toolkit for Ruby.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.executables = ['ruby-shoes']

  s.add_dependency "log4jruby"
  s.add_dependency "swt", "~>0.17"
  s.add_dependency "furoshiki", ">=0.1.2"
  s.add_dependency "nokogiri" # For converting the manual to HTML
  s.add_dependency "after_do"

  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "pry"

  s.add_development_dependency "rspec", "~>2.10"
  s.add_development_dependency "rake"

  s.add_development_dependency "yard"
  s.add_development_dependency "kramdown"
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'jruby-lint'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
