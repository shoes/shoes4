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
    it_behaves_like 'positioning through :_position'
    it_behaves_like 'positions the first element in the top left'

    describe 'two elements added' do
      include_context 'two slot children'

      it 'positions an element in the same row as long as they fit' do
        element2.top.should eq subject.top
      end

      it 'positions it next to the other element as long as it fits' do
        element2.left.should eq element.right
      end

      describe 'when the elements dont fit next to each other' do
        let(:input_opts){ {width: 80} }
        it_behaves_like 'arranges elements underneath each other'
      end
    end
  end
end
