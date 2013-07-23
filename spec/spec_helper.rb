require 'simplecov'

# using coveralls to publish test coverage statistics
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start

SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'rspec'
require 'pry'
require 'shoes'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

Shoes.load_backend(:mock)

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
