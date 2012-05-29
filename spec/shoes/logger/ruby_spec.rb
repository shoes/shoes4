require 'spec_helper'
require 'logger'

describe Shoes::Logger::Ruby do
  it "delegates to a Logger instance" do
    ::Logger.any_instance.should_receive(:debug).with("Foo bar baz!")
    subject.debug("Foo bar baz!")
  end
end
