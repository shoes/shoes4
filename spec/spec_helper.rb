SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'code_coverage'
require 'rspec'
require 'rspec/its'
require 'pry'
require 'shoes'
require 'async_helper'
require 'shoes/helpers/fake_element'

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
