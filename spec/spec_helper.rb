require 'simplecov'
SimpleCov.start

$:<< '../lib'

require 'rspec'

require 'pry'
require 'shoes'

Dir["./spec/support/**/*.rb"].each {|f| require f}

