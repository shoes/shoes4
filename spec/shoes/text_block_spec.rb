require 'shoes/spec_helper'
require 'shoes/text_block'

describe Shoes::Text_block do
  subject { Shoes::Text_block.new("gui_container", "Hello, world!", 99, {}) }
    before :each do
      Shoes::Text_block.any_instance.stub(:gui_textblock_init)
      Shoes::Text_block.any_instance.stub(:gui_update_text)
    end

  describe "initialize" do
    it "should set accessors" do
      subject.gui_container.should == "gui_container"
      subject.text.should == "Hello, world!"
      subject.font_size.should == 99
    end

    it "should allow replace() to change the text" do
      subject.replace "good bye!"
      subject.text.should == "good bye!"
    end

    it "should allow text= to change the text" do
      subject.text = "good bye!"
      subject.text.should == "good bye!"
    end

    it "should return the text when to_s is called" do
      subject.to_s.should == "Hello, world!"
    end

    it "should list all of the strings and styled text \
        objects when contents() is called" do
      subject.contents.should == "Hello, world!"
    end
  end

  describe "font size" do
    it "should set banner to 48 pixels" do
      Shoes::Banner.any_instance.stub(:gui_textblock_init)
      Shoes::Banner.new(nil, "hello", {}).font_size.should == 48
    end

    it "should set title to 38 pixels" do
      Shoes::Title.any_instance.stub(:gui_textblock_init)
      Shoes::Title.new(nil, "hello", {}).font_size.should == 34
    end

    it "should set subtitle to 26 pixels" do
      Shoes::Subtitle.any_instance.stub(:gui_textblock_init)
      Shoes::Subtitle.new(nil, "hello", {}).font_size.should == 26
    end

    it "should set tagline to 18 pixels" do
      Shoes::Tagline.any_instance.stub(:gui_textblock_init)
      Shoes::Tagline.new(nil, "hello", {}).font_size.should == 18
    end

    it "should set caption to 14 pixels" do
      Shoes::Caption.any_instance.stub(:gui_textblock_init)
      Shoes::Caption.new(nil, "hello", {}).font_size.should == 14
    end

    it "should set para to 12 pixels" do
      Shoes::Para.any_instance.stub(:gui_textblock_init)
      Shoes::Para.new(nil, "hello", {}).font_size.should == 12
    end

    it "should set inscription to 10 pixels" do
      Shoes::Inscription.any_instance.stub(:gui_textblock_init)
      Shoes::Inscription.new(nil, "hello", {}).font_size.should == 10
    end
  end
end