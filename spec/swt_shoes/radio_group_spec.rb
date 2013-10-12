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

    describe 'after adding a button' do
      before :each do
         subject.add radio
      end

      it "only one button is added" do
        subject.length.should == 1
      end

      it "the correct button is added" do
        subject.include?(radio).should == true
      end
    end
  end

  describe "#remove" do
    before :each do
      subject.add(radio)
    end

    it "stops monitoring selection" do
      real.should_receive(:remove_selection_listener)
      subject.remove(radio)
    end

    it "removes one button" do
      subject.remove(radio)
      subject.length.should == 0
    end
  end

  describe "#select_only_one_radio_in_group" do
    let(:real_selected) { double('real').as_null_object }
    let(:radio_selected) { double('radio', real: real_selected) }
    before :each do
      subject.add(radio)
      subject.add(radio_selected)
    end
    after :each do 
      subject.select_only_one_radio_in_group(radio_selected) 
    end

    it "turns on the selected radio" do
      real_selected.should_receive(:set_selection).with(true) 
    end

    it "turns off the non-selected radios" do
      real.should_receive(:set_selection).with(false)
    end
  end

end
