require 'swt_shoes/spec_helper'

describe Shoes::Swt::Radio do
  include_context "swt app"

  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :app => shoes_app,
                     :width= => true, :width => 100,
                     :height= => true, :height => 200,
                     :group => nil, :blk => block).as_null_object }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Radio.new dsl, parent }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"
  it_behaves_like "togglable"

  describe "#initialize" do
    it "sets group to default" do
      expect(subject.group).to eq(Shoes::Swt::RadioGroup::DEFAULT_RADIO_GROUP)
    end
  end

  describe "#group=" do
    let(:group_name) { "New Group Name" }
    let(:radio_group) { double("radio_group").as_null_object }
    let(:group_lookup) { double('group_lookup', :[] => radio_group).as_null_object }
    before :each do
      Shoes::Swt::RadioGroup.stub(:group_lookup) { group_lookup }  
    end

    it "changes the group" do
      subject.group = group_name
      expect(subject.group).to eq(group_name)
    end

    it "adds to the new radio group" do
      group_lookup.should_receive(:[]).with group_name
      radio_group.should_receive(:add).with subject
      subject.group = group_name
    end

    it "removes from the old radio group" do
      group_lookup.should_receive(:[]).with Shoes::Swt::RadioGroup::DEFAULT_RADIO_GROUP
      radio_group.should_receive(:remove).with subject
      subject.group = group_name
    end
  end
end
