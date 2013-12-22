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
    it "delegates to the app" do
      expect(swt_app).to receive(:redraw)
      subject.redraw
    end

    it "should redraw on updating position" do
      expect(swt_app).to receive(:redraw)
      subject.update_position
    end
  end

  describe "sizing methods" do
    before(:each) do
      stub_with_sizes(height, width)
    end

    it "should use layout to get size" do
      expect(subject.get_size).to eq([width, height])
    end

    it "should use layout to get height" do
      expect(subject.get_height).to eq(height)
    end
  end

  describe "generating layouts" do
    let(:layout) { create_layout(height, width) }

    before(:each) do
      stub_layout(layout)
    end

    it "should not shrink when no containing width" do
      expect(layout).to receive(:setWidth).never
      subject.generate_layout(nil, "text text")
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
      subject.generate_layout(nil, "text text")
    end
  end

  describe "contents alignment" do
    let(:fitter) { double("fitter") }
    let(:current_position) { Shoes::Slot::CurrentPosition.new }

    before(:each) do
      ::Shoes::Swt::TextBlockFitter.stub(:new) { fitter }
    end

    it "should set position for fitting single layout" do
      dsl.stub(:absolute_left) { 50 }

      layout = create_layout(:unused_height, 100)
      layout.stub(:get_line_bounds) { layout.bounds }
      fitter.stub(:fit_it_in) { [double("fitted_layout", layout: layout)] }

      expect(dsl).to receive(:absolute_right=).with(150)

      subject.contents_alignment(current_position)
    end

    it "should set position for fitting two layouts" do
      current_position.next_line_start = 0

      last_layout = create_layout(200, 100)
      last_layout.stub(:get_line_bounds) { last_layout.bounds }
      last_layout.stub(:line_metrics) { double("line_metrics", height: 10)}
      last_layout.stub(:spacing) { 0 }

      fitter.stub(:fit_it_in) {
        [:unused_layout, double("fitted_layout", layout: last_layout)]
      }

      expect(dsl).to receive(:absolute_right=)
      expect(dsl).to receive(:absolute_top=)

      subject.contents_alignment(current_position)
    end
  end

  it "should test links, contents and clearing" do
    pending "Waiting on re-enabling links and implementing contents"
  end

  def create_layout(height, width)
    bounds = double("bounds", height: height, width: width)
    double("layout", bounds: bounds).as_null_object
  end

  def stub_with_sizes(height, width)
    stub_layout(create_layout(height, width))
  end

  def stub_layout(layout)
    ::Swt::Font.stub(:new) { double("font") }
    ::Swt::TextStyle.stub(:new) { double("text_style") }
    ::Swt::TextLayout.stub(:new) { layout }
  end

end
