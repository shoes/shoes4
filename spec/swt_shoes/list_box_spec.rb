require 'swt_shoes/spec_helper'

describe Shoes::Swt::List_box do
  let(:items) { ["Pie", "Apple", "Sand"] }
  let(:dsl) { double('dsl', :items => items) }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { mock(:text => "")  }

  subject { Shoes::Swt::List_box.new dsl, parent, block }

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
end
