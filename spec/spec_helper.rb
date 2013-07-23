SHOESSPEC_ROOT = File.expand_path('..', __FILE__)
$LOAD_PATH << File.join('../lib', SHOESSPEC_ROOT)

require 'code_coverage'
require 'rspec'
require 'pry'
require 'shoes'
require 'guard'

include Guard


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
