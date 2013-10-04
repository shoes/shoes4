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
    let(:group_name) { "New Group Name" }
    let(:radio_group) { double("radio_group").as_null_object }
    let(:all_groups) { double('all_groups', :[] => radio_group).as_null_object }
    before :each do
      Shoes::Swt::RadioGroup.stub(:all_groups) { all_groups }  
    end

    it "change the group" do
      subject.group = group_name
      subject.group.should == group_name
    end
    it "add to the new radio group" do
      all_groups.should_receive(:[]).with group_name
      radio_group.should_receive(:add).with subject
      subject.group = group_name
    end
    it "remove from the old radio group" do
      all_groups.should_receive(:[]).with Shoes::Swt::RadioGroup::DEFAULT_RADIO_GROUP
      radio_group.should_receive(:remove).with subject
      subject.group = group_name
    end
  end

end
