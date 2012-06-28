require 'shoes/spec_helper'

describe Shoes::List_box do
  subject { Shoes::List_box.new(parent,
    input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { { :items => ["Wine", "Vodka", "Water"] } }
  let(:parent) { double("parent").as_null_object }

  it "should contain the correct items" do
    subject.items.should eq ["Wine", "Vodka", "Water"]
  end

  it "should allow us to change the items" do
    lb = subject
    lb.items = ["Pie", "Apple", "Pig"]
    lb.items.should eq ["Pie", "Apple", "Pig"]
  end
end
