require 'shoes/spec_helper'

shared_examples_for "Slot" do
  it "should be able to append" do
    subject.contents.should be_empty
    subject.append {para "foo"}
    subject.contents.size.should eq(1)
  end

  it_behaves_like "DSL container"
end
