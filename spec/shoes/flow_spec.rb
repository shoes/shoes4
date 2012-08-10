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

  it "should set default values" do
    parent.stub(:gui)
    f = Shoes::Flow.new(parent)
    f.width.should == 1.0
    f.height.should == 0
  end
end
