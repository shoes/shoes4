require 'shoes/spec_helper'

describe Shoes::Slot do
  include_context "dsl app"
  let(:parent) { app }

  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  subject(:slot) { Shoes::Slot.new(app, parent, left: left, top: top, width: width, height: height) }

  it_behaves_like "object with dimensions"

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
end
