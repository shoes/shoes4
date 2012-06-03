require 'spec_helper'

Shoes.configuration.backend = :mock

shared_examples = File.join(File.dirname(__FILE__), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
