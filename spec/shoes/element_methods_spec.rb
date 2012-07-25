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

  describe "flow" do
    it "creates a Shoes::Flow" do
      blk = Proc.new {}
      opts = Hash.new
      flow = subject.flow opts, &blk
      flow.should be_an_instance_of(Shoes::Flow)
    end
  end

  describe "line" do
    it "creates a Shoes::Line" do
      subject.line(10, 15, 20, 30).should be_an_instance_of(Shoes::Line)
    end
  end

  describe "oval" do
    it "creates a Shoes::Oval" do
      subject.oval(10, 50, 250).should be_an_instance_of(Shoes::Oval)
    end
  end

  describe "shape" do
    let(:app) { ElementMethodsShoeLaces.new }
    subject {
      app.shape {
        move_to 400, 300
        line_to 400, 200
        line_to 100, 100
        line_to 400, 300
      }
    }

    it { should be_an_instance_of(Shoes::Shape) }

    it "receives style from app" do
      green = Shoes::COLORS.fetch :green
      app.style[:stroke] = green
      subject.stroke.should eq(green)
    end
  end

  describe "rgb" do
    let(:red) { 100 }
    let(:green) { 149 }
    let(:blue) { 237 }
    let(:alpha) { 133 } # cornflower
    let(:app) { ElementMethodsShoeLaces.new }

    it "sends args to Shoes::Color" do
      Shoes::Color.should_receive(:new).with(red, green, blue, alpha)
      app.rgb(red, green, blue, alpha)
    end

    it "defaults to opaque" do
      Shoes::Color.should_receive(:new).with(red, green, blue, Shoes::Color::OPAQUE)
      app.rgb(red, green, blue)
    end
  end

  describe "stroke" do
    let(:app) { ElementMethodsShoeLaces.new }
    let(:color) { Shoes::COLORS.fetch :tomato }

    specify "returns a color" do
      app.stroke(color).class.should eq(Shoes::Color)
    end

    # This works differently on the app than on a normal element
    specify "sets on receiver" do
      app.stroke color
      app.style[:stroke].should eq(color)
    end

    specify "applies to subsequently created objects" do
      app.stroke color
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:stroke].should eq(color)
      end
      app.oval(10, 10, 100, 100)
    end
  end

  describe "strokewidth" do
    let(:app) { ElementMethodsShoeLaces.new }
    specify "returns a number" do
      app.strokewidth(4).should eq(4)
    end

    specify "sets on receiver" do
      app.strokewidth 4
      app.style[:strokewidth].should eq(4)
    end

    specify "applies to subsequently created objects" do
      app.strokewidth 6
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:strokewidth].should eq(6)
      end
      app.oval(10, 10, 100, 100)
    end
  end

  describe "fill" do
    let(:app) { ElementMethodsShoeLaces.new }
    let(:color) { Shoes::COLORS.fetch :tomato }

    specify "returns a color" do
      app.fill(color).class.should eq(Shoes::Color)
    end

    # This works differently on the app than on a normal element
    specify "sets on receiver" do
      app.fill color
      app.style[:fill].should eq(color)
    end

    specify "applies to subsequently created objects" do
      app.fill color
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:fill].should eq(color)
      end
      app.oval(10, 10, 100, 100)
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
