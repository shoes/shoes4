require 'shoes/spec_helper'

describe Shoes::App do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  subject { Shoes::App.new(opts, &input_blk) }

  describe "initialize" do
    it "should set accessors from constructor args" do
      Shoes::App.any_instance.stub(:flow)
      subject.should respond_to :width
      subject.should respond_to :height
      subject.should respond_to :title
      subject.should respond_to :resizable
      #subject.blk.should == input_blk
    end

    it "should set default accessor values" do
      input_blk = Proc.new {}
      args = {}
      Shoes::App.any_instance.stub(:flow)
      app = Shoes::App.new args, &input_blk
      app.width.should == 600
      app.height.should == 500
      app.title.should == 'Shoes 4'
      app.resizable.should be_true
    end

    it "should set accessors from opts" do
      input_blk = Proc.new {}
      args = {:width => 1, :height => 2, :title => "Shoes::App Spec", :resizable => false}
      Shoes::App.any_instance.stub(:flow)
      app = Shoes::App.new args, &input_blk
      app.width.should == 1
      app.height.should == 2
      app.title.should == "Shoes::App Spec"
      app.resizable.should be_false
    end

    it "initializes style hash" do
      style = Shoes::App.new.style
      style.class.should eq(Hash)
    end
  end

  # This behavior is different from Red Shoes. Red Shoes doesn't expose
  # the style hash on Shoes::App.
  describe "style" do
    subject { Shoes::App.new }
    it_behaves_like "object with style"
  end

  describe "strokewidth" do
    it "defaults to 1" do
      subject.style[:strokewidth].should eq(1)
    end

    it "passes default to objects" do
      subject.line(0, 100, 100, 0).style[:strokewidth].should eq(1)
    end

    it "passes new values to objects" do
      subject.strokewidth 10
      subject.line(0, 100, 100, 0).style[:strokewidth].should eq(10)
    end
  end

  describe "stroke" do
    let(:black) { Shoes::COLORS[:black] }
    let(:goldenrod) { Shoes::COLORS[:goldenrod] }
    it "defaults to black" do
      subject.style[:stroke].should eq(black)
    end

    it "passes default to objects" do
      subject.oval(100, 100, 100).style[:stroke].should eq(black)
    end

    it "passes new value to objects" do
      subject.stroke goldenrod
      subject.oval(100, 100, 100).style[:stroke].should eq(goldenrod)
    end
  end

  describe "default styles" do
    it "is independent among Shoes::App instances" do
      app1 = Shoes::App.new
      app2 = Shoes::App.new

      app1.strokewidth 10
      app1.line(0, 100, 100, 0).style[:strokewidth].should == 10

      # .. but does not affect app2
      app2.line(0, 100, 100, 0).style[:strokewidth].should_not == 10
    end
  end

  describe "background" do
    subject     { Shoes::App.new }
    let(:white) { Shoes::COLORS[:white] }
    let(:blue)  { Shoes::COLORS[:blue] }
    
    it "should set the default background color to white" do
      subject.background.should == white
    end

    it "should allow users to set the background from args" do
      input_blk = Proc.new {}
      args = { :background => blue }
      app = Shoes::App.new args, &input_blk
      app.background.should == blue
    end
  end
end
