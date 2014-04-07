require 'shoes/spec_helper'

shared_examples_for "Slot" do
  it "should be able to append" do
    subject.contents.should be_empty
    our_subject = subject
    app.execute_block Proc.new { our_subject.append {para "foo"} }
    subject.contents.size.should eq(1)
  end

  it_behaves_like 'prepending'
  it_behaves_like 'clearing'
  it_behaves_like 'element one positioned with bottom and right'
end

shared_context 'one slot child' do
  let(:ele_opts) {Hash.new}
  let(:element) {Shoes::FakeElement.new(nil, {height: 100,width: 50}.merge(ele_opts))}

  before :each do
    subject.add_child element
  end
end

shared_context 'two slot children' do
  include_context 'one slot child'
  let(:element2) {Shoes::FakeElement.new nil, height: 200, width: 70}

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

shared_context 'element one with bottom and right' do
  let(:ele_bottom) {24}
  let(:ele_right) {49}
  let(:ele_opts) {{right: ele_right, bottom: ele_bottom}}
end

shared_examples_for 'positioning through :_position' do

  let(:element) {Shoes::FakeElement.new nil, height: 100, width: 50}

  def add_child_and_align
    subject.add_child element
    subject.contents_alignment
  end

  it 'sends the child the :_position method to position it' do
    expect(element).to receive(:_position).and_call_original
    add_child_and_align
  end

  it 'does not send _position again if the position did not change' do
    add_child_and_align
    expect(element).not_to receive(:_position)
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

shared_examples_for 'element one positioned with bottom and right' do
  include_context 'one slot child'
  include_context 'contents_alignment'
  include_context 'element one with bottom and right'

  it 'positions the element from its right' do
    expect(element.absolute_right).to eq (subject.absolute_right - ele_right - 1)
  end

  it 'positions the element from its bottom' do
    expect(element.absolute_bottom).to eq (subject.absolute_bottom - ele_bottom - 1)
  end
end

shared_examples_for 'positions the first element in the top left' do
  include_context 'one slot child'
  include_context 'contents_alignment'
  it 'positions a single object at the same top as self' do
    element.absolute_top.should eq subject.element_top
  end

  it 'positions a single object at the same left as self' do
    element.absolute_left.should eq subject.element_left
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
    element2.absolute_top.should eq element.absolute_bottom + 1
  end

  it 'still positions it at the start of the line (e.g. self.left)' do
    element2.absolute_left.should eq subject.absolute_left
  end

  it 'has a stack height according to its contents' do
    subject.height.should eq (element.height + element2.height)
  end

  it 'has an absolute_bottom of top + height' do
    subject.absolute_bottom.should eq (subject.absolute_top + subject.height - 1)
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
    element.absolute_left.should eq input_opts[:margin]
  end

  it 'respects the left margin for the second element' do
    element2.absolute_left.should eq input_opts[:margin]
  end

  it 'respects the top margin for the first element' do
    element.absolute_top.should eq input_opts[:margin]
  end
end

shared_examples_for 'prepending' do
  include_context 'two slot children'
  let(:prepend1) {double 'prepend1'}
  let(:prepend2) {double 'prepend2'}

  describe 'one element' do
    before :each do
      subject.prepend do
        subject.add_child prepend1
      end
    end

    it 'as the first' do
      subject.contents.first.should eq prepend1
    end

    it 'has a total of 3 elements then' do
      subject.contents.size.should == 3
    end
  end

  describe 'two elements' do
    before :each do
      subject.prepend do
        subject.add_child prepend1
        subject.add_child prepend2
      end
    end

    it 'has prepend1 as the first child' do
      subject.contents.first.should eq prepend1
    end

    it 'has prepend2 as the second child' do
      subject.contents[1].should eq prepend2
    end

    it 'has a total of 4 children' do
      subject.contents.size.should == 4
    end
  end

  describe 'two times' do
    before :each do
      subject.prepend { subject.add_child prepend1 }
      subject.prepend {subject.add_child prepend2 }
    end

    it 'has the last prepended element as the first' do
      subject.contents.first.should eq prepend2
    end

    it 'has the first prepended element as the second' do
      subject.contents[1].should eq prepend1
    end

    it 'has a total of 4 children' do
      subject.contents.size.should == 4
    end
  end
end

shared_examples_for 'clearing' do
  include_context 'two slot children'

  describe '#clear' do
    it 'removes all contents' do
      subject.clear
      subject.contents.should be_empty
    end
  end

  describe 'Element#remove' do
    it 'removees the element' do
      element.parent = subject
      element.remove
      subject.contents.should_not include element
    end
  end
end
