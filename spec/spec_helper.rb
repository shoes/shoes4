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
require 'guard'
require 'vcr'
require 'async_helper'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end

include Guard

Shoes.load_backend(:mock)

RSpec.configure do |config|
  config.before(:each) do
    Shoes.logger.level = Logger::ERROR
    backend_is :swt do
      require 'shoes/swt'
      Swt.stub(:event_loop)
      Swt::Widgets::Shell.any_instance.stub(:open)
    end
  end
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_examples = File.expand_path('../shoes/shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
