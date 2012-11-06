require 'swt_shoes/spec_helper'

describe Shoes::Swt::EditLine do
  let(:dsl) { double('dsl', opts: {}) }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::EditLine.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Text.stub(:new) { real }
    ::Swt::Widgets::Text.stub(:text=) { real }
  end

  it_behaves_like "movable element"
  it_behaves_like "clearable native element"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:text=).with("some text")
      subject.text = "some text"
    end
  end
end
