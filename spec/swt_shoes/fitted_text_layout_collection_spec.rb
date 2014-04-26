require 'swt_shoes/spec_helper'

describe Shoes::Swt::FittedTextLayoutCollection do
  include_context "swt app"

  let(:first_layout) { create_layout("first", "first") }
  let(:second_layout) { create_layout("second", "rest") }

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

  context "with one layout" do
    subject { Shoes::Swt::FittedTextLayoutCollection.new([first_layout], default_text_styles) }

    it "should have length" do
      expect(subject.length).to eq(1)
    end

    it "delegates drawing" do
      subject.draw(gc)
      expect(first_layout).to have_received(:draw)
    end

    it "applies segment styling" do
      styles = [[0..1, [double("segment", opts:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_layout).to have_received(:set_style).with(expected_style, 0..1)
    end

    it "only gets default styling if segment is missing opts" do
      styles = [[0..1, [double("segment")]]]
      subject.style_segment_ranges(styles)
      expect(first_layout).to have_received(:set_style).with(default_text_styles, 0..1)
    end

    context "links" do
      it "styles links" do
        styles = [[0..1, [create_link("linky")]]]
        subject.style_segment_ranges(styles)

        expected_style = style_with(underline: true, stroke: ::Shoes::COLORS[:blue])
        expect(first_layout).to have_received(:set_style).with(expected_style, 0..1)
      end

      it "creates a link segment" do
        link = create_link("f")
        styles = [[0..1, [link]]]
        subject.create_links(styles)

        expect(link.gui.link_segments).to have(1).item
      end
    end

    context "layout ranges" do
      it "picks within the first range" do
        result = subject.layout_ranges(0..2)
        expect(result).to eql([[first_layout, 0..2]])
      end

      it "picks the full first range if too large value requested" do
        result = subject.layout_ranges(0..first_layout.text.length + 10)
        expect(result).to eql([[first_layout, 0..first_layout.text.length]])
      end
    end
  end

  context "with two layouts" do
    subject { Shoes::Swt::FittedTextLayoutCollection.new([first_layout, second_layout], default_text_styles) }

    it "should have length" do
      expect(subject.length).to eq(2)
    end

    it "picks range in first layout" do
      result = subject.layout_ranges(0..2)
      expect(result).to eql([[first_layout, 0..2]])
    end

    it "picks range in second layout" do
      result = subject.layout_ranges(5..7)
      expect(result).to eql([[second_layout, 0..2]])
    end

    it "spans both layouts" do
      result = subject.layout_ranges(2..7)
      expect(result).to eql([[first_layout, 2..5],
                             [second_layout,  0..2]])
    end

    it "applies segment styling in first layout" do
      styles = [[0..2, [double("segment", opts:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_layout).to have_received(:set_style).with(expected_style, 0..2)
      expect(second_layout).to_not have_received(:set_style)
    end

    it "applies segment styling in second layout" do
      styles = [[5..7, [double("segment", opts:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_layout).to_not have_received(:set_style)
      expect(second_layout).to have_received(:set_style).with(expected_style, 0..2)
    end

    it "applies segment styling in both layouts" do
      styles = [[2..7, [double("segment", opts:{stroke: :blue})]]]
      subject.style_segment_ranges(styles)

      expected_style = style_with(stroke: :blue, fg: :blue)
      expect(first_layout).to have_received(:set_style).with(expected_style, 2..5)
      expect(second_layout).to have_received(:set_style).with(expected_style, 0..2)
    end

    context "links" do
      let(:link) { create_link("rstres") }

      it "creates link segments in both layouts" do
        styles = [[2..7, [link]]]
        subject.create_links(styles)

        expect(link.gui.link_segments).to have(2).items
      end

      it "clears links before re-creating them" do
        styles = [[2..7, [link]]]

        subject.create_links(styles)
        subject.create_links(styles)

        expect(link.gui.link_segments).to have(2).items
      end
    end
  end

  def create_layout(name, text)
    bounds = double("bounds", x: 0, y: 0, height: 0)
    inner_layout = double(name, text: text,
                          line_bounds: bounds, line_count: 1)

    layout = Shoes::Swt::FittedTextLayout.new(inner_layout, 0, 0)
    layout.stub(:draw)
    layout.stub(:set_style)
    layout.stub(:get_location).and_return(double("position", x: 0, y: 0))
    layout
  end

  def create_link(text)
    Shoes::Link.new(shoes_app, parent, [text])
  end

  def style_with(opts={})
    default_text_styles.merge(opts)
  end
end
