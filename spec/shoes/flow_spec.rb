require 'shoes/spec_helper'

describe Shoes::Flow do
  let(:app) { parent }
  let(:parent) { Shoes::App.new }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143} }
  subject { Shoes::Flow.new(parent, input_opts, &input_block) }

  describe "dsl" do
    # dsl methods require :app
    let(:input_opts) { {:app => app} }

    it_behaves_like "dsl container"
  end

  describe "initialize" do
    it "sets accessors" do
      subject.parent.should == parent
      subject.width.should == 131
      subject.height.should == 137
      subject.margin.should == 143
      subject.blk.should == input_block
    end

    backend_is :swt do
      it "sets top slot" do
        Shoes.configuration.backend::ShoesLayout.any_instance.should_receive(:top_slot).at_least(:once)
        subject
      end
    end
  end

  it "sets default values" do
    f = Shoes::Flow.new(parent)
    f.width.should == 1.0
    f.height.should == 0
  end
end
