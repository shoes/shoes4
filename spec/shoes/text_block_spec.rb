require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:mock_parent) { mock(gui: "mock gui", add_child: true) }
  subject { Shoes::TextBlock.new(mock_parent, "Hello, world!", 99, {}) }

  describe "initialize" do
    it "creates gui object" do
      subject.gui.should_not be_nil
    end
  end
end
