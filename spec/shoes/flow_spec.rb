require 'shoes/spec_helper'
require_relative 'helpers/fake_element'

describe Shoes::Flow do
  let(:app) { parent }
  let(:parent) { Shoes::App.new }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { Hash.new }

  subject { Shoes::Flow.new(app, parent, input_opts, &input_block) }

  it_behaves_like "clickable object"
  it_behaves_like "hover and leave events"
  it_behaves_like "Slot"

  describe "initialize" do
    let(:input_opts) { {:width => 131, :height => 137} }
    it "sets accessors" do
      subject.parent.should == parent
      subject.width.should == 131
      subject.height.should == 137
      subject.blk.should == input_block
    end

    describe 'margines' do
      let(:input_opts){{margin: 143}}
      it 'sets the margins' do
        subject.margin.should == [143, 143, 143, 143]
      end
    end
  end

  it "sets default values" do
    f = Shoes::Flow.new(app, parent)
    f.width.should == app.width
    f.height.should == 0
  end

  it "clears with an optional block" do
    subject.should_receive(:clear).with(&input_block)
    subject.clear &input_block
  end

  describe "positioning" do

    let(:element) {Shoes::FakeElement.new height: 100, width: 50}
    let(:element2) {Shoes::FakeElement.new height: 200, width: 70}

    before :each do
      subject.add_child element
    end

    it 'sends the child the :_position method to position it' do
      element.should_receive :_position
      subject.contents_alignment
    end

    describe 'one element added' do
      before :each do
        subject.contents_alignment
      end

      it 'positions a single object at the same top as self' do
        element.top.should eq subject.top
      end

      it 'positions a single object at the same left as self' do
        element.left.should eq subject.left
      end
    end

    describe 'two elements added' do

      before :each do
        subject.add_child element2
        subject.contents_alignment
      end

      it 'positions an element in the same row as long as they fit' do
        element2.top.should eq subject.top
      end

      it 'positions it next to the other element as long as it fits' do
        element2.left.should eq element.right
      end

      describe 'when the elements dont fit next to each other' do
        let(:input_opts){ {width: 80} }
        it 'positions an element beneath a previous element' do
          element2.top.should eq element.bottom
        end

        it 'still positions it at the start of the line (e.g. self.left)' do
          element2.left.should eq subject.left
        end
      end

    end
  end
end
