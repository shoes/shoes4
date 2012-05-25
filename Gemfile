source "http://rubygems.org"

require 'rbconfig'

gem 'facets'
gem 'log4jruby'
gem 'swt'

group :development do
  gem "ruby-debug"
  gem "guard"
  gem "guard-rspec"
  #gem "spork"

  #gem 'yard'

  unless Config::CONFIG['host_os']
    # A Jruby compatible gem for 'pygmentize'
    gem "albino"

    ## Dependencies for Rocco.
    ## Really... All Three Markdown gems?!
    #gem "bluecloth"
    gem "redcarpet"
    #gem "rdiscount"
    gem "rocco"
  end
end

group :test do
  unless Config::CONFIG['host_os']
    #gem "mechanize"
  end
  gem "gherkin"
  gem "cucumber"
  gem "rspec", "~> 2.0"
  gem "rake"
  #gem "shoes-cucumber"
end

