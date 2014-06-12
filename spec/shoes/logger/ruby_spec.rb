require 'spec_helper'

describe Shoes::Logger::Ruby do
  it "delegates to a Logger instance" do
    expect_any_instance_of(::Logger).to receive(:debug).with("Foo bar baz!")
    subject.debug("Foo bar baz!")
  end
end
