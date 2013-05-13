require 'shoes/spec_helper'

describe Shoes::TextBlock do
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }
  let(:text_link) { Shoes::Link.new(:link, ['Hello']) }
  subject { Shoes::TextBlock.new(app, parent, "#{text_link}, world!", 99, {app: app}) }

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
  end

  describe "#to_s" do
    it "is the same as #text" do
      text = subject.text
      subject.to_s.should eq(text)
    end
  end

  describe "#replace" do
    it "replaces text" do
      subject.replace "Goodbye Cruel World"
      subject.text.should eq("Goodbye Cruel World")
    end

    it "allows two arguments" do
      subject.replace "Goodbye Cruel World, ", text_link
      subject.text.should eq("Goodbye Cruel World, Hello")
    end
  end

  describe "font" do
    it "sets the default font to Arial" do
      subject.font.should eql "Arial"
    end

    it "should allow setting the font with :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: "Helvetica", app: app })
      s.font.should eql "Helvetica"
    end

    it "should allow setting the font size with :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: "Helvetica 33px", app: app })
      s.font.should eql "Helvetica"
      s.font_size.should eql 33
    end

    it "should accept fonts surrounded with questionmarks when using :family" do
      s = Shoes::TextBlock.new(app, parent, "Hello, world!", 99, { font: '"Comic Sans" 13px', app: app })
      s.font.should eql "Comic Sans"
      s.font_size.should eql 13
    end

  end
end
