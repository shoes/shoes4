require 'swt_shoes/spec_helper'

describe Shoes::Swt::ListBox do
  let(:items) { ["Pie", "Apple", "Sand"] }
  let(:dsl) { double('dsl', items: items, opts: {}) }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { mock(text: "", setSize: true, addSelectionListener: true) }

  subject { Shoes::Swt::ListBox.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Combo.stub(:new) { real }
  end

  it "should return nil when nothing is highlighted" do
    subject.text.should be_nil
  end

  it "should call 'items' when updating values" do
    real.should_receive(:items=).with(["hello"])
    subject.update_items(["hello"])
  end

  it "should respond to choose" do
    subject.should respond_to :choose
  end

  it "should call text= when choosing" do
    real.should_receive(:text=).with "Bacon"
    subject.choose "Bacon"
  end
end
