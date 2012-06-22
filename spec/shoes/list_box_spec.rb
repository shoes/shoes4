require 'shoes/spec_helper'

describe Shoes::List_box do
  subject { Shoes::List_box.new("gui_container",
    { :app => "app", :items => ["Wine", "Vodka", "Water"] }, "input block") }

  before :each do
    Shoes::List_box.any_instance.stub :gui_update_items
    Shoes::List_box.any_instance.stub :gui_list_box_init
  end

  it "should contain the correct items" do
    subject.items.should eq ["Wine", "Vodka", "Water"]
  end

  it "should allow us to change the items" do
    lb = subject
    lb.should_receive :gui_update_items
    lb.items = ["Pie", "Apple", "Pig"]
    lb.items.should eq ["Pie", "Apple", "Pig"]
  end
end
