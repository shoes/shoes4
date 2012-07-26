require 'shoes/spec_helper'

describe Shoes::Flow do
  let(:parent) { double("parent") }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143} }
  subject { Shoes::Flow.new(parent, input_opts, &input_block) }

  describe "dsl" do
    # dsl methods require :app
    let(:app) { double("app") }
    let(:input_opts) { {:app => app} }

    before :each do
      parent.stub(:gui)
      app.stub(:gui)
    end

    it_behaves_like "dsl container"
  end

  describe "initialize" do
    before :each do
      parent.should_receive(:gui)
    end

    it "should set accessors" do
      subject.parent.should == parent
      subject.width.should == 131
      subject.height.should == 137
      subject.margin.should == 143
      subject.blk.should == input_block
    end
  end
  #let(:display) { SWT::Widgets::Display.getDefault }
  #let(:parent_container) { SWT::Widgets::Shell.new(display) }
  #
  #it "should have a SWT Composite" do
  #  flow = Shoes::Flow.new(parent_container)
  #  flow.container.should be_a SWT::Layouts::Composite
  #end
  #
  #it "should horizontally stack 3 widgets" do
  #  button1 = button2 = button3 = nil
  #  Shoes::Flow.new(parent_container) do
  #    button1 = button("Button1")
  #    button2 = button("Button2")
  #    button3 = button("Button3")
  #  end
  #  button1.left.should >= 0
  #  button2.left.should >= button1.left + button1.width
  #end
  #
  #it "should have a margin" do
  #  button1 = nil
  #  flow = Shoes::Flow.new(parent_container, :margin => 10) do
  #    button1 = button("Button1")
  #  end
  #  button1.top.should == 10
  #  button1.left.should == 10
  #end
  #
  #after :all do
  #  SWT::Widgets::Display.getDefault.dispose
  #end

end
