require 'shoes/spec_helper'

describe Shoes::Radio do
  include_context "dsl app"

  subject(:radio) { Shoes::Radio.new(app, parent, group, input_opts, input_block) }
  let(:group) { :a_group }

  it_behaves_like "checkable"
  it_behaves_like "object with state"

  # only one radio in a group can be checked

  describe "#initialize" do
    it "sets accessors" do
      subject.parent.should == parent
      subject.group.should == group
      subject.blk.should == input_block
    end
  end

  describe "#group=" do
    it "changes the group" do
      subject.group = "New Group"
      subject.group.should == "New Group"
    end
  end
end
