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

  describe 'clearing' do
    before :each do
      10.times do
        Shoes::TextBlock.new app, slot, ['text'], 20
      end
    end

    it 'sends remove to all children' do
      subject.contents.each do |element|
        expect(element).to receive(:remove).and_call_original
      end
      slot.clear
    end
  end
end
