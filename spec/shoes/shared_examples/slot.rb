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
  let(:ele_opts) {Hash.new}
  let(:element) {Shoes::FakeElement.new({height: 100,
                                         width: 50}.merge ele_opts)}

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

shared_context 'element one with top and left' do
  let(:ele_top) {22}
  let(:ele_left) {47}
  let(:ele_opts) {{left: ele_left, top: ele_top}}
end

shared_examples_for 'positioning through :_position' do
  it 'sends the child the :_position method to position it' do
    element = Shoes::FakeElement.new height: 100, width: 50
    subject.add_child element
    element.should_receive :_position
    # message expectation for _position seems to not execute the method, hence
    # these values aren't set appropriately
    element.stub absolute_right: 0, absolute_bottom: 0
    subject.contents_alignment
  end
end

shared_examples_for 'element one positioned with top and left' do
  it 'positions the element at its left value' do
    element.absolute_left.should eq subject.absolute_left + ele_left
  end

  it 'positions the element at its top value' do
    element.absolute_top.should eq subject.absolute_top + ele_top
  end
end

shared_examples_for 'positions the first element in the top left' do
  include_context 'one slot child'
  include_context 'contents_alignment'
  it 'positions a single object at the same top as self' do
    element.absolute_top.should eq subject.absolute_top
  end

  it 'positions a single object at the same left as self' do
    element.absolute_left.should eq subject.absolute_left
  end

  it 'has a slot height of the element height' do
    subject.height.should eq element.height
  end

  describe 'top and left' do
    include_context 'element one with top and left'
    it_behaves_like 'element one positioned with top and left'
  end
end

shared_examples_for 'arranges elements underneath each other' do
  include_context 'two slot children'
  include_context 'contents_alignment'

  it 'positions an element beneath a previous element' do
    element2.absolute_top.should eq element.absolute_bottom
  end

  it 'still positions it at the start of the line (e.g. self.left)' do
    element2.absolute_left.should eq subject.absolute_left
  end

  it 'has a stack height according to its contents' do
    subject.height.should eq (element.height + element2.height)
  end

  it 'has an absolute_bottom of top + height' do
    subject.absolute_bottom.should eq (subject.absolute_top + subject.height)
  end

  describe 'element one with top and left' do
    include_context 'element one with top and left'
    it_behaves_like 'element one positioned with top and left'

    describe 'positions element2 disregarding element1' do
      it 'has the same absolute left as the slot' do
        element2.absolute_left.should eq subject.absolute_left
      end

      it 'has the same absolute top as the slot' do
        element2.absolute_top.should eq subject.absolute_top
      end
    end
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

shared_examples_for 'taking care of margin' do
  include_context 'two slot children'
  include_context 'contents_alignment'

  it 'respects the left margin for the first element' do
    element.absolute_left.should eq opts[:margin]
  end

  it 'respects the left margin for the second element' do
    element2.absolute_left.should eq opts[:margin]
  end

  it 'respects the top margin for the first element' do
    element.absolute_top.should eq opts[:margin]
  end
end
