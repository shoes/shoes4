require 'shoes/spec_helper'

shared_examples_for "Slot" do
  it "should be able to append" do
    subject.contents.should be_empty
    our_subject = subject
    app.instance_eval do our_subject.append {para "foo"} end
    subject.contents.size.should eq(1)
  end

  it_behaves_like "DSL container"
end

shared_context 'one slot child' do
  let(:element) {Shoes::FakeElement.new height: 100, width: 50}

  before :each do
    subject.add_child element
  end
end

shared_context 'two slot children' do
  include_context 'one slot child'
  let(:element2) {Shoes::FakeElement.new height: 200, width: 70}

  before :each do
    subject.add_child element2
  end
end

shared_context 'contents_alignment' do
  before :each do
    subject.contents_alignment
  end
end

shared_examples_for 'positioning through :_position' do
  it 'sends the child the :_position method to position it' do
    element = Shoes::FakeElement.new height: 100, width: 50
    subject.add_child element
    element.should_receive :_position
    subject.contents_alignment
  end
end

shared_examples_for 'positions the first element in the top left' do
  include_context 'one slot child'
  include_context 'contents_alignment'
  it 'positions a single object at the same top as self' do
    element.top.should eq subject.top
  end

  it 'positions a single object at the same left as self' do
    element.left.should eq subject.left
  end

  it 'has a slot height of the element height' do
    subject.height.should eq element.height
  end
end

shared_examples_for 'arranges elements underneath each other' do
  include_context 'two slot children'
  include_context 'contents_alignment'

  it 'positions an element beneath a previous element' do
    element2.top.should eq element.bottom
  end

  it 'still positions it at the start of the line (e.g. self.left)' do
    element2.left.should eq subject.left
  end

  it 'has a stack height according to its contents' do
    subject.height.should eq (element.height + element2.height)
  end
end

shared_examples_for 'set height and contents alignment' do
  include_context 'two slot children'

  it 'contents_alignment returns the height of the content' do
    subject.contents_alignment.should eq (element.height + element2.height)
  end

  it 'still has the same height though' do
    old_height = subject.height
    subject.contents_alignment
    subject.height.should eq old_height
  end
end
