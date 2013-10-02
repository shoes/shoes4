require 'swt_shoes/spec_helper'

describe Shoes::Swt::Radio do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :width= => true, :height= => true, 
    :group => nil, blk: block) }
  let(:parent) { double('parent', real: true, dsl: double(contents: []) ) }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Radio.new dsl, parent }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"

  describe "#initialize" do
    it "sets group to default" do
      subject.group.should == Shoes::Swt::RadioGroup::DEFAULT_RADIO_GROUP
    end
  end

  describe "#group=" do
    let(:group) { "New Group" }


    it "change the group" do
      subject.group = group
      subject.group.should == group
    end
    it "should be added to the new radio group" do
      # I have no idea how to test this
    end
    it "should be removed from the old radio group" do
      # I have no idea how to test this
    end
  end

end
