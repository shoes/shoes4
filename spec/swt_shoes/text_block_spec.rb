require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  include_context "swt app"

  let(:height) { 100 }
  let(:width)  { 200 }
  let(:margin) { 10 }
  let(:dsl) { double("dsl", app: shoes_app,
                     margin_left: 0, margin_right: 0,
                     margin_top: 0, margin_bottom: 0).as_null_object }

  subject { Shoes::Swt::TextBlock.new(dsl) }

  it_behaves_like "paintable"
  it_behaves_like "togglable"

  # reported nil, caused trouble in simple-downloader.rb
  it 'initially responds with empty fitted layouts' do
    expect(subject.fitted_layouts).to be_empty
  end

  describe "generating layouts" do
    let(:layout) { create_layout(width, height) }

    before(:each) do
      stub_layout(layout)
    end

    it "should not shrink when enough containing width" do
      expect(layout).to receive(:setWidth).never
      subject.generate_layout(width + 10, "text text")
    end

    it "shrinks when too long for containing width" do
      containing_width = width - 10
      expect(layout).to receive(:setWidth).with(containing_width)
      subject.generate_layout(containing_width, "text text")
    end

    it "passes text along to layout" do
      expect(layout).to receive(:setText).with("text text")
      subject.generate_layout(0, "text text")
    end
  end

  describe "bounds checking" do
    it "delegates to fitted layout" do
      layout = create_layout(0,0)
      subject.fitted_layouts = [layout]
      expect(layout).to receive(:in_bounds?)

      subject.in_bounds?(1,1)
    end
  end

  describe "contents alignment" do
    let(:layout_width) { 100 }
    let(:layout_height) { 200 }
    let(:line_height) { 10 }
    let(:layout) { create_layout(layout_width, layout_height) }
    let(:fitted_layout) { double("fitted_layout", layout: layout) }
    let(:fitter) { double("fitter") }
    let(:current_position) { Shoes::Slot::CurrentPosition.new(0, 0) }

    before(:each) do
      ::Shoes::Swt::TextBlockFitter.stub(:new) { fitter }
      fitter.stub(:fit_it_in) { [fitted_layout] }
      layout.stub(:line_metrics) { double("line_metrics", height: line_height)}
    end

    describe "with single layout" do
      before(:each) do
        dsl.stub(:absolute_left)   { 50 }
        dsl.stub(:absolute_top)    { 0 }
        dsl.stub(:absolute_bottom) { layout_height }
        layout.stub(:line_count)   { 1 }
      end

      it "positions single line of text" do
        expect(dsl).to receive(:absolute_right=).with(layout_width + 50)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end

      it "positions single line with margin" do
        dsl.stub(margin_left: margin, margin_right: margin,
                 margin_top: margin, margin_bottom: margin)

        expect(dsl).to receive(:absolute_right=).with(layout_width + 50 + margin)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height + 2 * margin)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end

      it "pushes to next line if ends in newline" do
        layout.stub(:text) { "text\n" }

        expect(dsl).to receive(:absolute_right=).with(50)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height)

        subject.contents_alignment(current_position)
      end

      it "disposes of prior layouts" do
        subject.contents_alignment(current_position)
        expect(fitted_layout).to receive(:dispose)

        subject.contents_alignment(current_position)
      end
    end

    describe "with two layouts" do
      before(:each) do
        dsl.stub(:parent) { double("dsl parent", absolute_left: 0) }
        dsl.stub(:absolute_bottom) { layout_height }

        current_position.next_line_start = 0

        fitter.stub(:fit_it_in) {
          [:unused_layout, double("fitted_layout", layout: layout)]
        }
      end

      it "positions in two layouts" do
        expect(dsl).to receive(:absolute_right=).with(layout_width)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end

      it "positions in two layouts with margins" do
        dsl.stub(margin_left: margin, margin_right: margin,
                 margin_top: margin, margin_bottom: margin)

        expect(dsl).to receive(:absolute_right=).with(layout_width + margin)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height + 2 * margin)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end
    end
  end

  context "links" do
    let(:link)     { Shoes::Link.new(shoes_app, subject, ["link"])  }

    before(:each) do
      dsl.stub(:links) { [link] }
      swt_app.stub(:remove_listener)
    end

    it "clears links" do
      expect(link).to receive(:clear)
      subject.clear
    end

    it "clears links on replace" do
      expect(link).to receive(:clear)
      subject.replace("text")
    end
  end

  def create_layout(width, height, text="layout text")
    bounds = double("bounds", height: height, width: width)
    double("layout",
           get_line_bounds: bounds, bounds: bounds,
           spacing: 0, text: text).as_null_object
  end

  def stub_layout(layout)
    ::Swt::Font.stub(:new) { double("font") }
    ::Swt::TextStyle.stub(:new) { double("text_style") }
    ::Swt::TextLayout.stub(:new) { layout }
  end

end
