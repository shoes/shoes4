require 'code_coverage'
require "shoes/swt"
require "spec_helper"

RSpec.configure do |config|
  config.before(:each) do
    Swt.stub(:event_loop)
    Shoes::Swt::App.any_instance.stub(flush: true)
    Swt::Widgets::Shell.any_instance.stub(:open)
    Swt::Widgets::MessageBox.any_instance.stub(:open)
  end
end

shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
