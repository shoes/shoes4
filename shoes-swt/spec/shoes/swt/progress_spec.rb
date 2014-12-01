require 'shoes/swt/spec_helper'

describe Shoes::Swt::Progress do
  include_context "swt app"

  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', app: shoes_app).as_null_object }
  let(:real) { double('real', disposed?: false, :disposed? => false).as_null_object }

  subject { Shoes::Swt::Progress.new dsl, parent }

  before :each do
    allow(parent).to receive(:real)
    allow(::Swt::Widgets::ProgressBar).to receive(:new) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "updating visibility"

  it "should have a method called fraction=" do
    expect(subject).to respond_to :fraction=
  end

  it "should multiply the value by 100 when calling real.selection" do
    expect(real).to receive(:selection=).and_return(55)
    subject.fraction = 0.55
  end

  it "should round up correctly" do
    expect(real).to receive(:selection=).and_return(100)
    subject.fraction = 0.999
  end

  context "with disposed real element" do
    before :each do
      allow(real).to receive(:disposed?) { true }
    end

    it "shouldn't set selection" do
      expect(real).not_to receive(:selection=)
      subject.fraction = 0.55
    end
  end
end
