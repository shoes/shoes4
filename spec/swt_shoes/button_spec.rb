require 'swt_shoes/spec_helper'

describe Shoes::Swt::Button do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :text => text) }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Button.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "movable object with disposable real element"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:set_text).with(text)
      subject
    end

    it "passes block to real element" do
      real.should_receive(:addSelectionListener).with(block)
      subject
    end
  end
end
