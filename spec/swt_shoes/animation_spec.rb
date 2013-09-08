require 'swt_shoes/spec_helper'

describe Shoes::Swt::Animation do
  let(:dsl) { double('dsl', :stopped? => false, :removed? => false, :blk => block) }
  let(:app) { double 'app', :real => app_real, top_slot: double('top_slot').as_null_object }
  let(:block) { double 'block' }
  let(:display) { ::Swt.display }
  let(:app_real) { double('app_real').as_null_object }
  subject { Shoes::Swt::Animation.new dsl, app }

  before :each do
    display.stub(:timer_exec)
    dsl.stub(:framerate) { 10 }
    dsl.stub(:current_frame)
    dsl.stub(:increment_frame)
  end

  it "triggers an Swt timer" do
    display.should_receive(:timer_exec)
    subject
  end

  it "gets framerate" do
    dsl.should_receive(:framerate)
    subject
  end

  describe "task" do
    let(:task) { subject.task }

    before :each do
      app_real.stub(:disposed?) { false }
      block.stub(:call)
    end

    it "calls block" do
      block.should_receive(:call)
      task.call
    end

    it "gets framerate" do
      dsl.should_receive(:framerate)
      task.call
    end

    it "triggers redraw" do
      aspect = Shoes::Swt::RedrawingAspect.new app_real, double
      app_real.should_receive(:flush)
      task.call
      aspect.remove_redraws
    end

    it "counts frames" do
      dsl.should_receive(:increment_frame)
      task.call
    end
  end
end
