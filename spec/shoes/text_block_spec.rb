require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:mock_parent) { mock(gui: "mock gui", add_child: true) }
  subject { Shoes::TextBlock.new(mock_parent, "Hello, world!", 99, {}) }

  describe "initialize" do
    it "creates gui object" do
      subject.gui.should_not be_nil
    end
  end

  describe "text" do
    it "sets text when the object is created" do
      subject.text.should eql "Hello, world!"
    end

    it "allows us to change the text" do
      s = subject
      s.text = "Goodbye Cruel World"
      s.text.should eql "Goodbye Cruel World"
    end

    it "should call redraw when changing text" do
      Shoes::Mock::TextBlock.any_instance.should_receive :redraw
      subject.text = "Goodbye Cruel World"
    end
  end
end
