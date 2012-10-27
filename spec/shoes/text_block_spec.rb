require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, {app: app} }
  subject { Shoes::TextBlock.new(parent, "Hello, world!", 99, {}) }

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

    it "calls redraw when changing text" do
      Shoes.configuration.backend::TextBlock.any_instance.should_receive :redraw
      subject.text = "Goodbye Cruel World"
    end
  end

  describe "font" do
    it "sets the default font to Arial" do
      subject.font.should eql "Arial"
    end

    it "should allow setting the font with :family" do
      s = Shoes::TextBlock.new(parent, "Hello, world!", 99, { family: "Helvetica" })
      s.font.should eql "Helvetica"
    end

    it "should allow setting the font size with :family" do
      s = Shoes::TextBlock.new(parent, "Hello, world!", 99, { family: "Helvetica 33px" })
      s.font.should eql "Helvetica"
      s.font_size.should eql 33
    end

    it "should accept fonts surrounded with questionmarks when using :family" do
      s = Shoes::TextBlock.new(parent, "Hello, world!", 99, { family: '"Comic Sans" 13px' })
      s.font.should eql "Comic Sans"
      s.font_size.should eql 13
    end

  end
end
