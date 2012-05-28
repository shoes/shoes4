if RUBY_PLATFORM =~ /java/
  require 'spec_helper'
  require 'java'
  require 'support/log4j-1.2.16.jar'
  require 'log4jruby'

  describe Shoes::Logger::Log4j do
    it "delegates to a Log4jruby::Logger instance" do
      Log4jruby::Logger.any_instance.should_receive(:debug).with("Foo bar baz!")
      subject.debug("Foo bar baz!")
    end
  end
end
