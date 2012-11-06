require 'swt_shoes/spec_helper'

describe Shoes::Swt::Button do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :text => text) }
  let(:parent) { double('parent') }
  let(:block) { proc{} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Button.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    parent.stub(:dsl){mock(contents: [])}
    dsl.stub(:width=)
    dsl.stub(:height=)
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "movable element", 140, 300
  #it_behaves_like "clearable native element"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:set_text).with(text)
      subject
    end

    it "passes block to real element" do
      real.should_receive(:addSelectionListener).with(&block)
      subject
    end
  end
end
