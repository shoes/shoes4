require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextBlock do
  include_context "swt app"

  let(:height) { 100 }
  let(:width)  { 200 }
  let(:margin) { 10 }
  let(:dsl) { double("dsl", app: shoes_app, text: "text",
                     margin_left: 0, margin_right: 0,
                     margin_top: 0, margin_bottom: 0,
                     pass_coordinates?: nil).as_null_object }

  subject { Shoes::Swt::TextBlock.new(dsl, swt_app) }

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like "clickable backend"

  # reported nil, caused trouble in simple-downloader.rb
  it 'initially responds with empty segments' do
    expect(subject.segments).to be_empty
  end

  describe "bounds checking" do
    it "delegates to segment" do
      segment = double()
      subject.segments = [segment]
      expect(segment).to receive(:in_bounds?)

      subject.in_bounds?(1,1)
    end
  end

  describe "contents alignment" do
    let(:layout_width) { 100 }
    let(:layout_height) { 200 }
    let(:line_height) { 10 }

    let(:bounds) { double("bounds", height: layout_height, width: layout_width) }
    let(:unused_bounds) { double("unused bounds", height: 0, width: 0) }

    let(:fitter) { double("fitter") }
    let(:segment) { create_segment }
    let(:second_segment) { create_segment }

    let(:current_position) { Shoes::Slot::CurrentPosition.new(0, 0) }

    before(:each) do
      allow(::Shoes::Swt::TextBlock::Fitter).to receive(:new) { fitter }
      allow(fitter).to receive(:fit_it_in).and_return([segment], [second_segment])
    end

    describe "with single segment" do
      before(:each) do
        allow(dsl).to receive(:absolute_left)   { 50 }
        allow(dsl).to receive(:absolute_top)    { 0 }
        allow(dsl).to receive(:absolute_bottom) { layout_height }
      end

      it "positions single line of text" do
        expect(dsl).to receive(:absolute_right=).with(layout_width + 50 - 1)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height - 1)

        when_aligns_and_positions

        expect(current_position.y).to eq(layout_height - line_height + 1)
      end

      it "positions single line with margin" do
        allow(dsl).to receive_messages(margin_left: margin, margin_right: margin,
                 margin_top: margin, margin_bottom: margin)

        expect(dsl).to receive(:absolute_right=).with(layout_width + 50 + margin - 1)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height + 2 * margin - 1)

        when_aligns_and_positions

        expect(current_position.y).to eq(layout_height - line_height + 1)
      end

      it "pushes to next line if ends in newline" do
        allow(dsl).to receive(:text) { "text\n" }

        expect(dsl).to receive(:absolute_right=).with(50)
        expect(dsl).to receive(:absolute_right=).with(149)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height - 1)

        when_aligns_and_positions

        expect(current_position.y).to eq(layout_height + 1)
      end

      it "is aligns and positions safely without segments" do
        allow(fitter).to receive(:fit_it_in).and_return([])
        when_aligns_and_positions
      end

      it "disposes of prior segments" do
        subject.contents_alignment(current_position)
        expect(segment).to receive(:dispose)

        subject.contents_alignment(current_position)
      end

      it "should not dispose any segments" do
        expect(segment).not_to receive(:dispose)
        expect(second_segment).not_to receive(:dispose)

        subject.contents_alignment(current_position)
      end

      context "on the second call" do
        before(:each) do
          subject.contents_alignment(current_position)
        end

        it "should only dispose old segment" do
          expect(segment).to receive(:dispose)
          expect(second_segment).not_to receive(:dispose)

          subject.contents_alignment(current_position)
        end

        it "should dispose all segments on remove" do
          expect(segment).to receive(:dispose).at_least(1).times
          expect(second_segment).to receive(:dispose).at_least(1).times

          subject.contents_alignment(current_position)
          subject.remove
        end
      end

      context "when doesn't fit" do
        it "bails out early" do
          allow(fitter).to receive(:fit_it_in).and_return([])
          subject.contents_alignment(current_position)
        end
      end
    end

    describe "with two segments" do
      before(:each) do
        allow(dsl).to receive(:parent) { double("dsl parent", absolute_left: 0) }
        allow(dsl).to receive(:absolute_bottom) { layout_height }

        current_position.next_line_start = 0

        allow(fitter).to receive(:fit_it_in) {
          [create_segment("unused segment"),
           create_segment("segment")]
        }
      end

      it "positions in two segments" do
        expect(dsl).to receive(:absolute_right=).with(layout_width - 1)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height - 1)

        when_aligns_and_positions

        expect(current_position.y).to eq(layout_height - line_height + 1)
      end

      it "positions in two segments with margins" do
        allow(dsl).to receive_messages(margin_left: margin, margin_right: margin,
                 margin_top: margin, margin_bottom: margin)

        expect(dsl).to receive(:absolute_right=).with(layout_width + margin - 1)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height + 2 * margin - 1)

        when_aligns_and_positions

        expect(current_position.y).to eq(layout_height - line_height + 1)
      end
    end
  end

  context "links" do
    let(:link)     { Shoes::Link.new(shoes_app, ["link"])  }

    before(:each) do
      allow(dsl).to receive(:links) { [link] }
    end

    it "clears links" do
      expect(link).to receive(:remove)
      subject.remove
    end

    it "clears links on replace" do
      expect(link).to receive(:remove)
      subject.replace("text")
    end
  end

  def create_segment(name="segment", width=layout_width,
                    height=layout_height, line_height=line_height)
    bounds = double("bounds", width: width, height: height)
    double(name, disposed?: false,
           width: width, height: height,
           last_line_width: width, last_line_height: line_height,
           bounds: bounds)
  end

  def when_aligns_and_positions
    subject.contents_alignment(current_position)
    subject.adjust_current_position(current_position)
  end
end
