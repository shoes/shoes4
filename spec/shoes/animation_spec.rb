require 'shoes/spec_helper'

shared_examples_for Shoes::Animation do
  it "should start" do
    subject.start
    subject.should_not be_stopped
  end

  it "should stop" do
    subject.stop
    subject.should be_stopped
  end

  it "should toggle on" do
    subject.stop
    subject.toggle
    subject.should_not be_stopped
  end

  it "should toggle off" do
    subject.start
    subject.toggle
    subject.should be_stopped
  end

  it "increments frame" do
    frame = subject.current_frame
    subject.increment_frame
    subject.current_frame.should eq(frame + 1)
  end
end

describe Shoes::Animation do
  let(:app) { double('app') }
  let(:app_gui) { double('app gui') }
  let(:opts) { {:app => app} }
  let(:block) { double('block') }
  subject { Shoes::Animation.new opts, block }

  before :each do
    app.should_receive(:gui) { app_gui }
  end

  it_behaves_like Shoes::Animation

  it "sets default framerate" do
    subject.framerate.should eq(24)
  end

  it "sets current frame to 0" do
    subject.current_frame.should eq(0)
  end

  it { should_not be_stopped }

  describe "with framerate" do
    let(:opts) { {:framerate => 36, :app => app} }

    it "sets framerate" do
      subject.framerate.should eq(36)
    end

    it_behaves_like Shoes::Animation
  end
end
