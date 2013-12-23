require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_fitter'

describe Shoes::Swt::TextBlockFitter do
  let(:dsl) { double('dsl', parent: parent_dsl, text: "Text goes here",
                     absolute_left: 25, absolute_top: 75,
                     margin_left: 1, margin_top: 1) }

  let(:parent_dsl) { double('parent_dsl',
                            absolute_left: 0,
                            width: 100, height: 200) }

  let(:text_block) { double('text_block', dsl: dsl) }

  let(:current_position) { double('current_position') }

  subject { Shoes::Swt::TextBlockFitter.new(text_block, current_position) }

  before(:each) do
    text_block.stub(:generate_layout)
  end

  describe "determining available space" do
    it "should use the current position" do
      with_current_position(50, 0, 20)
      expect(subject.available_space).to eq([50, 20])
    end

    it "should offset by parent with current position" do
      parent_dsl.stub(width: 100, absolute_left: 20)
      with_current_position(0, 0, 30)
      expect(subject.available_space).to eq([120, 30])
    end

    it "should move to next line" do
      parent_dsl.stub(width: 100)
      with_current_position(10, 20, 30, true)
      expect(subject.available_space).to eq([100, :unbounded])
    end
  end

  describe "layout generation" do
    it "should be delegated to the text block" do
      expect(text_block).to receive(:generate_layout).with(150, "Test")
      subject.generate_layout(150, "Test")
    end
  end

  describe "finding what didn't fit" do
    it "should tell split text by offsets and heights" do
      layout = double('layout', line_offsets: [0, 5, 9], text: "Text Split")
      layout.stub(:line_metrics) { double('line_metrics', height: 50)}

      subject.split_text(layout, 55).should eq(["Text ", "Split"])
    end

    it "should be able to split text when too small" do
      layout = double('layout', line_offsets: [0, 10], text: "Text Split")
      layout.stub(:line_metrics).with(0) { double('line_metrics', height: 21)}
      layout.stub(:line_metrics).with(1) { raise "Boom" }

      subject.split_text(layout, 33).should eq(["Text Split", ""])
    end
  end

  describe "fit it in" do
    let(:bounds) { double('bounds', width: 100, height: 50)}
    let(:layout) { double('layout', get_bounds: bounds) }

    before(:each) do
      text_block.stub(:generate_layout) { layout }
    end

    it "should return first layout if it fits" do
      with_current_position(0, 0, 50)
      fitted_layouts = subject.fit_it_in

      expect(fitted_layouts.size).to eq(1)
      expect_fitted_with(fitted_layouts.first, layout, 26, 76)
    end

    it "should overflow to second layout" do
      bounds.stub(width: 50)
      layout.stub(text: "", line_offsets: [])

      with_current_position(50, 0, 20)
      fitted_layouts = subject.fit_it_in

      expect(fitted_layouts.size).to eq(2)
      expect_fitted_with(fitted_layouts.first, layout, 26, 76)
      expect_fitted_with(fitted_layouts.last,  layout, 1, 126)
    end
  end

  def with_current_position(x, y, next_line_start, moving_next=false)
    current_position.stub(:x) { x }
    current_position.stub(:y) { y }
    current_position.stub(:next_line_start) { next_line_start }
    current_position.stub(:moving_next) { moving_next }
  end

  def expect_fitted_with(fitted_layout, layout, left, top)
    expect(fitted_layout.layout).to eq(layout)
    expect(fitted_layout.left).to eq(left)
    expect(fitted_layout.top).to eq(top)
  end
end
