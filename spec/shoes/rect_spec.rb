require 'shoes/spec_helper'

shared_examples_for "basic rect" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Rect do
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  let(:app) { Shoes::App.new }
  let(:parent) { app }
  subject { Shoes::Rect.new(app, left, top, width, height) }

  it_behaves_like "basic rect"
  it_behaves_like "object with fill"
  it_behaves_like "object with stroke"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
end
