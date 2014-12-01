require 'shoes/spec_helper'
require 'shoes/helpers/fake_element'

describe Shoes::Flow do
  include_context "dsl app"

  subject(:flow) { Shoes::Flow.new(app, parent, input_opts, input_block) }

  it_behaves_like "clickable object"
  it_behaves_like "hover and leave events"
  it_behaves_like "Slot"

  describe "initialize" do
    let(:input_opts) { {:width => 131, :height => 137} }
    it "sets accessors" do
      expect(flow.parent).to eq(parent)
      expect(flow.width).to eq(131)
      expect(flow.height).to eq(137)
      expect(flow.blk).to eq(input_block)
    end

    describe 'margins' do
      let(:input_opts) { {margin: 143} }
      it 'sets the margins' do
        expect(flow.margin).to eq([143, 143, 143, 143])
      end
    end
  end

  it "sets default values" do
    f = Shoes::Flow.new(app, parent)
    expect(f.width).to eq(app.width)
    expect(f.height).to eq(0)
  end

  it "clears with an optional block" do
    expect(flow).to receive(:clear) do |&blk|
      expect(blk).to eq(input_block)
    end
    flow.clear &input_block
  end

  describe "positioning" do
    it_behaves_like 'positioning through :_position'
    it_behaves_like 'positions the first element in the top left'

    shared_examples_for 'positioning in the same line' do
      it 'positions an element in the same row as long as they fit' do
        expect(element2.absolute_top).to eq(flow.absolute_top)
      end

      it 'positions it next to the other element as long as it fits' do
        expect(element2.absolute_left).to eq(element.absolute_right + 1)
      end

      it 'has a slot height of the maximum value of the 2 elements' do
        expect(flow.height).to eq([element.height, element2.height].max)
      end
    end

    describe 'two elements added' do
      include_context 'two slot children'
      include_context 'contents_alignment'

      it_behaves_like 'positioning in the same line'

      describe 'exact fit' do
        let(:input_opts) {{width: element.width + element2.width}}
        it_behaves_like 'positioning in the same line'
      end

    end

    describe 'when the elements dont fit next to each other' do
      let(:input_opts){ {width: element.width + element2.width - 10} }
      it_behaves_like 'arranges elements underneath each other'

      describe 'and a third element that goes into the second line' do
        include_context 'three slot children'
        include_context 'contents_alignment'

        it 'positions the third element right next to the second' do
          expect(element3.absolute_left).to eq element2.absolute_right + 1
        end

        it 'positions the third element on the same height as element 2' do
          expect(element3.absolute_top).to eq element2.absolute_top
        end
      end
    end

    describe 'elements dont fit next to each other and set small height' do
      let(:input_opts) { {width: element.width + 10, height: element.height + 10} }
      it_behaves_like 'set height and contents alignment'
    end

    describe 'elements dont fit next to each other and set big height' do
      let(:input_opts){ {width: element.width + 10, height: 1000} }
      it_behaves_like 'set height and contents alignment'
    end

    describe 'with margins and two elements not fitting next to each other' do
      let(:input_opts){{width: element.width + 10, margin: 27}}
      it_behaves_like 'taking care of margin'
    end
  end

  describe 'scrolling' do
    include_context "scroll"
    subject(:flow) { Shoes::Flow.new(app, parent, opts) }

    context 'when scrollable' do
      let(:scroll) { true }

      it_behaves_like "scrollable slot"

      context 'when content overflows' do
        include_context "overflowing content"
        it_behaves_like "scrollable slot with overflowing content"
      end
    end

    context 'when slot is not scrollable' do
      let(:scroll) { false }

      its(:scroll) { should be_falsey }

      it "initializes scroll_top to 0" do
        expect(flow.scroll_top).to eq(0)
      end
    end
  end
end
