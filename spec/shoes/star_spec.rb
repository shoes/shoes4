require 'shoes/spec_helper'

shared_examples_for "basic star" do
  it "retains app" do
    subject.app.should eq(app)
  end

  it "creates gui object" do
    subject.gui.should_not be_nil
  end
end

describe Shoes::Star do
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 100 }
  let(:height) { 100 }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new(app, app) }
  subject { Shoes::Star.new(app, parent, left, top, 5, 50, 30) }

  it_behaves_like "basic star"
  it_behaves_like "object with fill"
  it_behaves_like "object with stroke"
  it_behaves_like "object with style"
  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
  it_behaves_like 'object with parent'
end
