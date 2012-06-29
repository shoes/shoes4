require 'shoes/spec_helper'
require 'shoes/text_block'

describe Shoes::Text_block do
  let(:mock_gui) { mock(:set_font, :update_text, :hidden, :new) }
  let(:mock_parent) { mock(:gui => "mock gui") }
  subject { Shoes::Text_block.new(mock_parent, "Hello, world!", 99, {}, nil) }

  describe "initialize" do
    it "should have the proper accessors" do
      s = subject
      s.should respond_to :contents
      s.should respond_to :replace
      s.should respond_to :text
      s.should respond_to :text=
      s.should respond_to :to_s
    end

    it "should set accessors" do
      s = subject
      s.text.should eql "Hello, world!"
      s.to_s.should eql "Hello, world!"
      s.contents.should eql "Hello, world!"
      s.font_size.should eql 99
    end

    it "should allow replace() to change the text" do
      s = subject
      s.replace "good bye!"
      s.text.should == "good bye!"
    end

    it "should allow text= to change the text" do
      s = subject
      s.text = "good bye!"
      s.text.should == "good bye!"
    end

    it "should return the text when to_s is called" do
      subject.to_s.should == "Hello, world!"
    end

    it "should list all of the strings and styled text \
        objects when contents() is called" do
      subject.contents.should == "Hello, world!"
    end
  end

  describe "font styles" do
    tb = Shoes::Mock::Text_block

    def sub(opts)
      opts.merge! :app => "app"
      Shoes::Text_block.new(mock_parent, "Hello, world!", 99, opts, nil)
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
        tb.any_instance.should_receive(:set_font).with(["Times New Roman"], anything, anything)
        sub({:family => 'Times New Roman'})
      end

      it "should set the correct font family when using :font" do
        tb.any_instance.should_receive(:set_font).with(["Times New Roman"], anything, anything)
        sub({:font => 'Times New Roman'})
      end

      it "should default to arial if the font family is missing" do
        tb.any_instance.should_receive(:set_font).with(["Arial"], anything, anything)
        sub({:font => 'none 12px'})
      end

      it "should allow us to set the font size" do
        tb.any_instance.should_receive(:set_font).with(anything, anything, 88)
        sub({:font => '"Times New Roman", Arial bold 88px'})
      end

      it "should allow us to set style options" do
        tb.any_instance.should_receive(:set_font).with(anything, [:bold, :none], anything)
        sub({:font => '"Times New Roman", Arial bold none 88'})
      end

      it "should react correctly if the font-string is empty" do
        tb.any_instance.should_receive(:set_font).with(["Arial"], [], nil)
        sub({:font => ''})
      end
    end

    describe "emphasis" do
      it "should handle normal correctly" do
        tb.any_instance.should_receive(:set_font).with(anything, [:normal], nil)
        sub({:emphasis => 'normal'})
      end

      it "should handle oblique correctly" do
        tb.any_instance.should_receive(:set_font).with(anything, [:oblique], nil)
        sub({:emphasis => 'oblique'})
      end

      it "should handle italic correctly" do
        tb.any_instance.should_receive(:set_font).with(anything, [:italic], nil)
        sub({:emphasis => 'italic'})
      end

      it "shouldn't change the font-family" do
        tb.any_instance.should_receive(:set_font).with(nil, [:italic], anything)
        sub({:emphasis => 'italic'})
      end
    end

    describe "hidden" do
      it "should hide the control when it receives :hidden" do
        tb.any_instance.should_receive(:hidden).with(true)
        sub({:hidden => true})
      end

      it "should not hide the control when it receives :hidden => false" do
        tb.any_instance.should_receive(:hidden).with(false)
        sub({:hidden => false})
      end
    end
  end
end
