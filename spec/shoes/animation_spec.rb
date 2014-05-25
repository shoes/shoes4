require 'shoes/spec_helper'

shared_examples_for Shoes::Animation do
  it "should start" do
    subject.start
    expect(subject).not_to be_stopped
  end

  it "should stop" do
    subject.stop
    expect(subject).to be_stopped
  end

  it "should toggle on" do
    subject.stop
    subject.toggle
    expect(subject).not_to be_stopped
  end

  it "should toggle off" do
    subject.start
    subject.toggle
    expect(subject).to be_stopped
  end

  it "increments frame" do
    frame = subject.current_frame
    subject.increment_frame
    expect(subject.current_frame).to eq(frame + 1)
  end
end

describe Shoes::Animation do
  let(:app) { double('app') }
  let(:app_gui) { double('app gui') }
  let(:opts) { {} }
  let(:block) { double('block') }
  subject { Shoes::Animation.new( app, opts, block ) }

  before :each do
    app.should_receive(:gui) { app_gui }
  end

  it_behaves_like Shoes::Animation

  it "sets default framerate" do
    expect(subject.framerate).to eq(10)
  end

  it "sets current frame to 0" do
    expect(subject.current_frame).to eq(0)
  end

  it { is_expected.not_to be_stopped }

  describe "with framerate" do
    let(:opts) { {:framerate => 36, :app => app} }

    it "sets framerate" do
      expect(subject.framerate).to eq(36)
    end

    it_behaves_like Shoes::Animation
  end
end
