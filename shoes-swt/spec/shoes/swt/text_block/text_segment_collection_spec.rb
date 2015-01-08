require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextBlock::TextSegmentCollection do
  include_context "swt app"

  let(:first_segment) { create_segment("first", "first") }
  let(:second_segment) { create_segment("second", "rest") }
  let(:dsl) { double("dsl", font: "", size: 16, style:{}) }

  let(:gc) { double("gc") }
  let(:default_text_styles) {
    {
      :fg          => :fg,
      :bg          => :bg,
      :strikecolor => :strikecolor,
      :undercolor  => :undercolor,
      :font_detail => {
        :name   => "font name",
        :size   => 12,
        :styles => [::Swt::SWT::NORMAL]
      }
    }
  }

  describe "with one segment" do
    subject { Shoes::Swt::TextBlock::TextSegmentCollection.new(dsl,
                                                         [first_segment],
                                                         default_text_styles) }

    before do
      allow(dsl).to receive(:text) { first_segment.text }
    end

    it "should have length" do
      expect(subject.length).to eq(1)
    end

    it "delegates drawing" do
      subject.draw(gc)
      expect(first_segment).to have_received(:draw)
    end

    it "applies segment styling" do
      styles = [[0..1, [double("segment", style:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_segment).to have_received(:set_style).with(expected_style, 0..1)
    end

    it "only gets default styling if segment is missing opts" do
      styles = [[0..1, [double("segment")]]]
      subject.style_segment_ranges(styles)
      expect(first_segment).to have_received(:set_style).with(default_text_styles, 0..1)
    end

    describe "links" do
      it "styles links" do
        dsl_link = create_link("linky")
        styles = [[0..1, [dsl_link]]]
        subject.style_segment_ranges(styles)

        dsl_style = dsl_link.style
        default_style = default_text_styles.merge(dsl_style)
        expected_style = default_style.merge({underline: true, stroke: ::Shoes::COLORS[:blue], fill: nil})
        expect(first_segment).to have_received(:set_style).with(expected_style, 0..1)
      end

      it "creates a link segment" do
        link = create_link("f")
        styles = [[0..1, [link]]]
        subject.create_links(styles)

        expect(link.gui.link_segments.size).to eq(1)
      end
    end

    describe "segment ranges" do
      it "picks within the first range" do
        result = subject.segment_ranges(0..2)
        expect(result).to eql([[first_segment, 0..2]])
      end

      it "picks the full first range if too large value requested" do
        result = subject.segment_ranges(0..first_segment.text.length + 10)
        expect(result).to eql([[first_segment, 0..first_segment.text.length]])
      end

      it "picks properly with empty range" do
        result = subject.segment_ranges(0...0)
        expect(result).to be_empty
      end
    end

    describe "relative text positions" do
      it "should choose the segment" do
        expect(subject.relative_text_position(0)).to eq(0)
      end

      it "should choose segment nearing end" do
        cursor = first_segment.text.length - 1
        expect(subject.relative_text_position(cursor)).to eq(cursor)
      end

      it "should choose segment at end" do
        cursor = first_segment.text.length
        expect_relative_position_at_end_of(cursor, first_segment)
      end

      it "should choose the segment when just past end" do
        cursor = first_segment.text.length + 1
        expect_relative_position_at_end_of(cursor, first_segment)
      end

      it "should choose right past end" do
        cursor = first_segment.text.length + 3
        expect_relative_position_at_end_of(cursor, first_segment)
      end

      it "should chooose the segment for -1" do
        expect_relative_position_at_end_of(-1, first_segment)
      end

      it "should allow crazy positions past the end" do
        expect_relative_position_at_end_of(1000, first_segment)
      end
    end
  end

  describe "with two segments" do
    subject { Shoes::Swt::TextBlock::TextSegmentCollection.new(dsl,
                                                         [first_segment, second_segment],
                                                         default_text_styles) }

    before do
      allow(dsl).to receive(:text) { first_segment.text + second_segment.text }
    end

    it "should have length" do
      expect(subject.length).to eq(2)
    end

    it "picks range in first segment" do
      result = subject.segment_ranges(0..2)
      expect(result).to eql([[first_segment, 0..2]])
    end

    it "picks range in second segment" do
      result = subject.segment_ranges(5..7)
      expect(result).to eql([[second_segment, 0..2]])
    end

    it "spans both segments" do
      result = subject.segment_ranges(2..7)
      expect(result).to eql([[first_segment, 2..5],
                             [second_segment,  0..2]])
    end

    it "applies segment styling in first segment" do
      styles = [[0..2, [double("segment", style:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_segment).to have_received(:set_style).with(expected_style, 0..2)
      expect(second_segment).to_not have_received(:set_style)
    end

    it "applies segment styling in second segment" do
      styles = [[5..7, [double("segment", style:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_segment).to_not have_received(:set_style)
      expect(second_segment).to have_received(:set_style).with(expected_style, 0..2)
    end

    it "applies segment styling in both segments" do
      styles = [[2..7, [double("segment", style:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_segment).to have_received(:set_style).with(expected_style, 2..5)
      expect(second_segment).to have_received(:set_style).with(expected_style, 0..2)
    end

    describe "links" do
      let(:link) { create_link("rstres") }

      it "creates link segments in both segments" do
        styles = [[2..7, [link]]]
        subject.create_links(styles)

        expect(link.gui.link_segments.size).to eq(2)
      end

      it "clears links before re-creating them" do
        styles = [[2..7, [link]]]

        subject.create_links(styles)
        subject.create_links(styles)

        expect(link.gui.link_segments.size).to eq(2)
      end
    end

    describe "relative text positions" do
      it "should choose the first segment" do
        expect(subject.relative_text_position(0)).to eq(0)
      end

      it "should choose first segment nearing end" do
        cursor = first_segment.text.length - 1
        expect(subject.relative_text_position(cursor)).to eq(cursor)
      end

      it "should choose second segment at end" do
        cursor = first_segment.text.length
        expect(subject.relative_text_position(cursor)).to eq(0)
      end

      it "should choose the second segment" do
        cursor = first_segment.text.length + 1
        expect(subject.relative_text_position(cursor)).to eq(1)
      end

      it "should chooose the second segment for -1" do
        expect_relative_position_at_end_of(-1, second_segment)
      end

      it "should allow crazy positions past the end" do
        expect_relative_position_at_end_of(1000, second_segment)
      end
    end
  end

  def create_segment(name, text)
    bounds = double("bounds", x: 0, y: 0, height: 0)
    layout = double(name, text: text,
                          line_bounds: bounds, line_count: 1)

    segment = Shoes::Swt::TextBlock::TextSegment.new(dsl, text, 1)
    segment.position_at(0, 0)
    allow(segment).to receive(:draw)
    allow(segment).to receive(:set_style)
    allow(segment).to receive(:get_location).and_return(double("position", x: 0, y: 0))
    allow(segment).to receive(:layout).and_return(layout)
    segment
  end

  def create_link(text)
    Shoes::Link.new(shoes_app, [text])
  end

  def style_with(style={})
    default_text_styles.merge(style)
  end

  def expect_relative_position_at_end_of(cursor, segment)
    expect(subject.relative_text_position(cursor)).to eq(segment.text.length)
  end
end
