require "shoes/swt"
require "spec_helper"

Shoes.load_backend("swt").initialize_backend

RSpec.configure do |config|
  config.before(:each) do
    allow(Swt).to receive(:event_loop)
    allow_any_instance_of(Shoes::Swt::App).to receive_messages(flush: true)
    allow_any_instance_of(Swt::Widgets::Shell).to receive(:open)
    allow_any_instance_of(Swt::Widgets::MessageBox).to receive(:open)
    # stubbed as otherwise all sorts of callbacks are added during certain specs,
    # which then fail because some doubles are not made for the methods called
    allow(Shoes::Swt::RedrawingAspect).to receive_messages new: true
  end

  # https://github.com/jruby/jruby/wiki/Persistence
  # mostly to allow stubbing/mocking of said java classes
  config.before(:all) do
    Swt::Widgets::Shell.__persistent__      = true
    Swt::Widgets::MessageBox.__persistent__ = true
    Swt::Path.__persistent__                = true
    Swt::Transform.__persistent__           = true
    Swt::Font.__persistent__                = true
    Swt::Widgets::Display.__persistent__    = true
  end
end

# as we do not create real apps most of the time there are no redraws and we
# we don't really want that during test execution either way as it adds stuff to
# methods that might break
def with_redraws
  allow(Shoes::Swt::RedrawingAspect).to receive(:new).and_call_original
  aspect = Shoes::Swt::RedrawingAspect.new swt_app, double
  begin
    yield
  ensure
    aspect.remove_redraws
  end
end

shared_examples = File.expand_path('../shared_examples/**/*.rb', __FILE__)
Dir[shared_examples].each { |f| require f }
