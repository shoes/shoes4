require 'shoes/spec_helper'

describe Shoes::Slot do
  include_context "dsl app"
  let(:parent) { app }

  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  let(:input_opts) { {left: left, top: top, width: width, height: height} }
  subject(:slot) { Shoes::Slot.new(app, parent, input_opts) }

  it_behaves_like "object with dimensions"

  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Slot.new(app, parent) }
    let(:subject_with_style) { Shoes::Slot.new(app, parent, arg_styles) }
  end

  describe "relative dimensions from parent" do
    subject { Shoes::Slot.new(app, parent, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Slot.new(app, parent, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end

  describe '#clear' do

    def add_text_block
      Shoes::TextBlock.new app, slot, ['text']
    end

    before :each do
      10.times do
        add_text_block
      end
    end

    it 'sends remove to all children' do
      subject.contents.each do |element|
        expect(element).to receive(:remove).and_call_original
      end
      subject.clear
    end

    it 'removes everything' do
      subject.clear
      expect(subject.contents).to be_empty
    end

    describe 'with a block' do
      before :each do
        subject.clear {add_text_block}
      end

      it 'has one element afterwards' do
        expect(subject.contents.size).to eq 1
      end
    end

  end

  describe '#remove_child' do
    let(:element) {Shoes::FakeElement.new subject}

    before :each do
      subject.add_child element
    end

    it 'removes the element' do
      subject.remove_child element
      expect(subject.contents).to be_empty
    end

    describe '2 elements' do
      let(:element2) {Shoes::FakeElement.new subject}

      before :each do
        subject.add_child element2
        subject.remove_child element
      end

      it 'has one element remaining' do
        expect(subject.contents.size).to eq 1
      end

      it 'has the second element remaining' do
        expect(subject.contents).to include element2
      end
    end
  end

  describe "hover" do
    let(:callable) { double("block", call: nil) }
    let(:block)    { Proc.new { callable.call } }

    it "doesn't need hover proc to be called" do
      expect(callable).to_not receive(:call)
      subject.mouse_hovered
    end

    it "calls block on mouse_hovered" do
      expect(callable).to receive(:call)

      subject.hover(block)
      subject.mouse_hovered
    end
  end

  describe "leave" do
    let(:callable) { double("block", call: nil) }
    let(:block)    { Proc.new { callable.call } }

    it "doesn't need leave proc to be called" do
      expect(callable).to_not receive(:call)
      subject.mouse_left
    end

    it "calls block on mouse_left" do
      expect(callable).to receive(:call)

      subject.leave(block)
      subject.mouse_left
    end
  end

  describe "create_bound_block" do
    let(:callable) { double("block", call: nil) }
    let(:block)    { Proc.new { callable.call(self) } }

    it "calls within the slot's context" do
      expect(subject).to receive(:eval_block).with(block)

      bound = subject.create_bound_block(block)
      bound.call
    end
  end

  describe "compute_content_height" do
    subject(:slot) { Shoes::Slot.new(app, parent) }

    it "finds 0 without children" do
      expect(compute_content_height).to eq(0)
    end

    describe "with children" do
      let(:child) {
        child_element = Shoes::FakeElement.new(subject, height: 100)
        child_element.absolute_top = 0
        child_element.gui = double('child gui').as_null_object
        child_element
      }

      before do
        subject.add_child(child)
      end

      it "finds height from child" do
        expect(compute_content_height).to eq(100)
      end

      it "ignores unpositioned children" do
        allow(child).to receive(:absolute_bottom) { nil }
        expect(compute_content_height).to eq(0)
      end

      it "ignores hidden child" do
        child.hide
        expect(compute_content_height).to eq(0)
      end

      it "ignores child that doesn't take up space" do
        allow(child).to receive(:takes_up_space?) { false }
        expect(compute_content_height).to eq(0)
      end
    end

    def compute_content_height
      subject.send(:compute_content_height)
    end
  end
end
