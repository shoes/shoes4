require "spec_helper"
require "shoes/swt"

Shoes.configuration.backend = :swt

RSpec.configure do |config|
  config.before(:each) do
    Shoes.logger.level = Logger::ERROR
    Swt.stub(:event_loop)
    Swt::Widgets::Shell.any_instance.stub(:open)
  end
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

shared_examples = File.join(File.expand_path(File.dirname(__FILE__)), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
