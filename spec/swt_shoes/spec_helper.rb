require "spec_helper"
require "shoes/swt"

Shoes.configuration.backend = :swt

RSpec.configure do |config|
  config.before(:each) do
    Swt.stub(:event_loop)
  end
end

shared_examples = File.join(File.expand_path(File.dirname(__FILE__)), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
