require 'spec_helper'

Shoes.configuration.backend = :mock

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_examples = File.join(File.dirname(__FILE__), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
