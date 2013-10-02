require 'swt_shoes/spec_helper'

describe Shoes::Swt::RadioGroup do
  let(:name) { "Group Name" }
  let(:real) { double('real', add_selection_listener: true, remove_selection_listener: true).as_null_object }
  let(:radio) { double('radio', real: real) }

  subject { Shoes::Swt::RadioGroup.new name }

  describe "#initialize" do
    it "sets name" do
      subject.name.should == "Group Name"
    end
  end

  describe "#add" do
    it "monitors selection" do
      real.should_receive(:add_selection_listener)
      subject.add(radio)
    end
    it "adds one button" do
      subject.add(radio)
      subject.count.should == 1
      subject.include?(radio).should == true
    end
  end

  describe "#remove" do
    before :each do
      subject.add(radio)
    end
    it "stop monitoring selection" do
      real.should_receive(:remove_selection_listener)
      subject.remove(radio)
    end
    it "remove one button" do
      subject.remove(radio)
      subject.count.should == 0
    end
  end

end
