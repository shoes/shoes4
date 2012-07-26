require 'shoes/spec_helper'


describe "text_block" do
  class ElementMethodsShoeLaces
    attr_accessor :gui
    include Shoes::ElementMethods
    def initialize
      @style = {}
    end
  end

  it "should set banner font size to 48" do
    subject = ElementMethodsShoeLaces.new.banner("hello!")
    subject.font_size.should eql 48
  end

  it "should set title font size to 34" do
    subject = ElementMethodsShoeLaces.new.title("hello!")
    subject.font_size.should eql 34
  end

  it "should set subtitle font size to 26" do
    subject = ElementMethodsShoeLaces.new.subtitle("hello!")
    subject.font_size.should eql 26
  end

  it "should set tagline font size to 18" do
    subject = ElementMethodsShoeLaces.new.tagline("hello!")
    subject.font_size.should eql 18
  end

  it "should set caption font size to 14" do
    subject = ElementMethodsShoeLaces.new.caption("hello!")
    subject.font_size.should eql 14
  end

  it "should set para font size to 12" do
    subject = ElementMethodsShoeLaces.new.para("hello!")
    subject.font_size.should eql 12
  end

  it "should set inscription font size to 10" do
    subject = ElementMethodsShoeLaces.new.inscription("hello!")
    subject.font_size.should eql 10
  end
end


describe "object with element methods" do
  subject { ElementMethodsShoeLaces.new }

  describe "arc" do
    it "creates a Shoes::Arc" do
      pending "arc implementation"
      arc = subject.arc
      raise "ARC FAILURE"
      arc.should be_an_instance_of(Shoes::Arc)
    end
  end

  #it "Should return 0 for left for button_one" do
  #  @gui.elements['button_one'].left.should be 0
  #end
  #
  #it "Should return 0 for top of button_one" do
  #  @gui.elements['button_one'].top.should be 0
  #end
  #
  #it "Should return 0 for left for button_two" do
  #  @gui.elements['button_two'].left.should be 0
  #end
  #
  #it "Should return 0 for top for button_two" do
  #  @gui.elements['button_two'].top.should be 147
  #end
  #
  #it "Should make button_one invisible when hide is called" do
  #  @gui.elements['button_one'].hide
  #  @gui.elements['button_one'].to_java.isVisible.should be false
  #end
  #
  #it "Should make button_one visible when show is called" do
  #  @gui.elements['button_one'].hide
  #  @gui.elements['button_one'].show
  #  @gui.elements['button_one'].to_java.isVisible.should be true
  #end
  #
  #it "Should make button_one hidden when toggle is called and it is visible" do
  #  @gui.elements['button_one'].show
  #  @gui.elements['button_one'].toggle
  #  @gui.elements['button_one'].to_java.isVisible.should be false
  #end
  #
  #it "Should make button_one visible after being hidden when toggle is called and it is hidden" do
  #  @gui.elements['button_one'].hide
  #  @gui.elements['button_one'].toggle
  #  @gui.elements['button_one'].to_java.isVisible.should be true
  #end


  #after(:all) do
  #  @gui.frame.dispose()
  #end
  #
end
