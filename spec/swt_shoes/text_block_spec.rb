require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  include_context "swt app"

  let(:height) { 100 }
  let(:width)  { 200 }
  let(:dsl) { double("dsl", app: shoes_app).as_null_object }

  subject { Shoes::Swt::TextBlock.new(dsl) }

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like "movable text", 10, 20

  describe "redrawing" do
    it "should redraw on updating position" do
      with_redraws do
        expect(swt_app).to receive(:redraw)
        subject.update_position
      end
    end
  end

  describe "generating layouts" do
    let(:layout) { create_layout(width, height) }

    before(:each) do
      stub_layout(layout)
    end

    it "should not strink when enough containing width" do
      expect(layout).to receive(:setWidth).never
      subject.generate_layout(width + 10, "text text")
    end

    it "should shrink when too long for containing width" do
      containing_width = width - 10
      expect(layout).to receive(:setWidth).with(containing_width)
      subject.generate_layout(containing_width, "text text")
    end

    it "should pass text along to layout" do
      expect(layout).to receive(:setText).with("text text")
      subject.generate_layout(0, "text text")
    end
  end

  describe "contents alignment" do
    let(:layout_width) { 100 }
    let(:layout_height) { 200 }
    let(:line_height) { 10 }
    let(:layout) { create_layout(layout_width, layout_height) }
    let(:fitter) { double("fitter") }
    let(:current_position) { Shoes::Slot::CurrentPosition.new(0, 0) }

    before(:each) do
      ::Shoes::Swt::TextBlockFitter.stub(:new) { fitter }
      fitter.stub(:fit_it_in) { [double("fitted_layout", layout: layout)] }
      layout.stub(:line_metrics) { double("line_metrics", height: line_height)}
    end

    describe "with single layout" do
      before(:each) do
        dsl.stub(:absolute_left)   { 50 }
        dsl.stub(:absolute_top)    { 0 }
        dsl.stub(:absolute_bottom) { layout_height }
        layout.stub(:line_count)   { 1 }
      end

      it "should position for single line of text" do
        expect(dsl).to receive(:absolute_right=).with(layout_width + 50)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end

      it "should push to next line if ends in newline" do
        layout.stub(:text) { "text\n" }

        expect(dsl).to receive(:absolute_right=).with(50)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height)

        subject.contents_alignment(current_position)
      end

      it "should set back width to dsl" do
        expect(dsl).to receive(:calculated_width=).with(layout_width)
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

      it "should set position for fitting two layouts" do
        expect(dsl).to receive(:absolute_right=).with(layout_width)
        expect(dsl).to receive(:absolute_bottom=).with(layout_height)
        expect(dsl).to receive(:absolute_top=).with(layout_height - line_height)

        subject.contents_alignment(current_position)
      end

      it "should set back width to dsl" do
        expect(dsl).to receive(:calculated_width=).with(layout_width)
        subject.contents_alignment(current_position)
      end
    end
  end

  it "should test links, contents and clearing" do
    pending "Waiting on re-enabling links and implementing contents"
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
