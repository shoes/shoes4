require 'shoes/spec_helper'
require 'shoes/text_block'

describe Shoes::Text_block do
  subject { Shoes::Text_block.new("gui_container", "Hello, world!", 99, {}) }
 
  before :each do
    Shoes::Text_block.any_instance.stub(:gui_textblock_init)
    Shoes::Text_block.any_instance.stub(:gui_update_text)
  end

  describe "initialize" do
    it "should have the proper accessors" do
      subject.should respond_to :text
      subject.should respond_to :replace
      subject.should respond_to :contents
    end

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

  describe "font styles" do
    tb = Shoes::Text_block

    def sub(opts)
      Shoes::Text_block.new("gui_container", "yo", 1337, opts)
    end

    describe "set_font" do
      it "should call gui_set_font when you pass :family" do
        tb.any_instance.should_receive :set_font
        sub({:family => "Arial"})
      end

      it "should call gui_set_font when you pass :font" do
        tb.any_instance.should_receive :set_font
        sub({:font => "Arial normal 12px"})
      end

      it "should set the corrent font family when using :family" do
        tb.any_instance.should_receive(:gui_set_font).with(["Times New Roman"], anything, anything)
        sub({:family => 'Times New Roman'})
      end

      it "should set the correct font family when using :font" do
        tb.any_instance.should_receive(:gui_set_font).with(["Times New Roman"], anything, anything)
        sub({:font => 'Times New Roman'})
      end

      it "should default to arial if the font family is missing" do
        tb.any_instance.should_receive(:gui_set_font).with(["Arial"], anything, anything)
        sub({:font => 'none 12px'})
      end

      it "should allow us to set the font size" do
        tb.any_instance.should_receive(:gui_set_font).with(anything, anything, 88)
        sub({:font => '"Times New Roman", Arial bold 88px'})
      end

      it "should allow us to set style options" do
        tb.any_instance.should_receive(:gui_set_font).with(anything, [:bold, :none], anything)
        sub({:font => '"Times New Roman", Arial bold none 88'})
      end

      it "should react correctly if the font-string is empty" do
        tb.any_instance.should_receive(:gui_set_font).with(["Arial"], [], nil)
        sub({:font => ''})
      end
    end

    describe "emphasis" do
      it "should handle normal correctly" do
        tb.any_instance.should_receive(:gui_set_font).with(anything, [:normal], nil)
        sub({:emphasis => 'normal'})
      end

      it "should handle oblique correctly" do
        tb.any_instance.should_receive(:gui_set_font).with(anything, [:oblique], nil)
        sub({:emphasis => 'oblique'})
      end

      it "should handle italic correctly" do
        tb.any_instance.should_receive(:gui_set_font).with(anything, [:italic], nil)
        sub({:emphasis => 'italic'})
      end

      it "shouldn't change the font-family" do
        tb.any_instance.should_receive(:gui_set_font).with(nil, [:italic], anything)
        sub({:emphasis => 'italic'})
      end
    end
  end
end