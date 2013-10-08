require 'shoes/spec_helper'

describe Shoes::Radio do
  subject { Shoes::Radio.new(app, parent, group, input_opts, input_block) }
  let(:group) { :a_group }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { Hash.new }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }

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
