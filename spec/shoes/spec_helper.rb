require 'spec_helper'

Shoes.configuration.backend = :mock

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
