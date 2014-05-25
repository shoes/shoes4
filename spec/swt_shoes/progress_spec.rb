require 'swt_shoes/spec_helper'

describe Shoes::Swt::Progress do
  include_context "swt app"

  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', app: shoes_app).as_null_object }
  let(:real) { double('real', disposed?: false, :disposed? => false).as_null_object }

  subject { Shoes::Swt::Progress.new dsl, parent }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::ProgressBar.stub(:new) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "togglable"

  it "should have a method called fraction=" do
    expect(subject).to respond_to :fraction=
  end

  it "should multiply the value by 100 when calling real.selection" do
    real.should_receive(:selection=).and_return(55)
    subject.fraction = 0.55
  end

  it "should round up correctly" do
    real.should_receive(:selection=).and_return(100)
    subject.fraction = 0.999
  end

  context "with disposed real element" do
    before :each do
      real.stub(:disposed?) { true }
    end

    it "shouldn't set selection" do
      real.should_not_receive(:selection=)
      subject.fraction = 0.55
    end
  end
end
