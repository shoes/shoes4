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
      Shoes::TextBlock.new app, slot, ['text'], 20
    end

    before :each do
      10.times do
        add_text_block
      end
    end

    it 'sends remove to all children' do
      slot.contents.each do |element|
        expect(element).to receive(:remove).and_call_original
      end
      slot.clear
    end

    it 'removes everything' do
      slot.clear
      expect(slot.contents).to be_empty
    end

    describe 'with a block' do
      before :each do
        slot.clear {add_text_block}
      end

      it 'has one element afterwards' do
        expect(slot.contents.size).to eq 1
      end
    end

  end
end
