require 'shoes/swt/spec_helper'

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
    allow(::Swt::Widgets::Button).to receive(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"
  it_behaves_like "updating visibility"

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
      allow(Shoes::Swt::RadioGroup).to receive(:group_lookup) { group_lookup }  
    end

    it "changes the group" do
      subject.group = group_name
      expect(subject.group).to eq(group_name)
    end

    it "adds to the new radio group" do
      expect(group_lookup).to receive(:[]).with group_name
      expect(radio_group).to receive(:add).with subject
      subject.group = group_name
    end

    it "removes from the old radio group" do
      expect(group_lookup).to receive(:[]).with Shoes::Swt::RadioGroup::DEFAULT_RADIO_GROUP
      expect(radio_group).to receive(:remove).with subject
      subject.group = group_name
    end
  end
end
