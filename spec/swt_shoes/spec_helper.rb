require 'code_coverage'
require "shoes/swt"
require "spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    Shoes.logger.level = Logger::ERROR
    Swt.stub(:event_loop)
    Swt::Widgets::Shell.any_instance.stub(:open)
  end
end

shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
