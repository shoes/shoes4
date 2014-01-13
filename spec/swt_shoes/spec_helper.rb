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

# as we do not create real apps most of the time there are no redraws and we
# we don't really want that during test execution either way as it adds stuff to
# methods that might break
def with_redraws(&blk)
  aspect = Shoes::Swt::RedrawingAspect.new swt_app, double
  yield
  aspect.remove_redraws
end

shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
