require "spec_helper"
require "shoes/swt"

module SwtBackendSpec
  def self.included(example_group)
    example_group.class_eval do
      let(:backend_name) { :swt }
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do
    Shoes.logger.level = Logger::ERROR
    Swt.stub(:event_loop)
    Swt::Widgets::Shell.any_instance.stub(:open)
  end

  # Enable the Shoes::Swt backend for specs marked with :swt
  config.include SwtBackendSpec, :swt
end

shared_examples = File.join(File.expand_path(File.dirname(__FILE__)), 'shared_examples', '**/*.rb')
Dir[shared_examples].each { |f| require f }
