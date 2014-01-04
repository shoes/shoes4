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
    it "should offset by parent with current position" do
      parent_dsl.stub(absolute_left: 20)
      with_current_position(15, 5, 30)
      expect(subject.available_space).to eq([105, 24])
    end

    it "should move to next line" do
      with_current_position(15, 5, 5)
      expect(subject.available_space).to eq([85, :unbounded])
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
    let(:layout) { double('layout', text: "something something",
                          line_offsets:[], get_bounds: bounds) }

    before(:each) do
      text_block.stub(:generate_layout) { layout }
    end

    it "should return first layout if it fits" do
      with_current_position(25, 75, 130)
      fitted_layouts = subject.fit_it_in

      expect(fitted_layouts.size).to eq(1)
      expect_fitted_with(fitted_layouts.first, layout, 26, 76)
    end

    it "should overflow to second layout" do
      bounds.stub(width: 50)

      with_current_position(25, 75, 95)
      fitted_layouts = subject.fit_it_in

      expect(fitted_layouts.size).to eq(2)
      expect_fitted_with(fitted_layouts.first, layout, 26, 76)
      expect_fitted_with(fitted_layouts.last,  layout, 1, 126)
    end
  end

  def with_current_position(x, y, next_line_start)
    dsl.stub(absolute_left: x, absolute_top: y)
    current_position.stub(:next_line_start) { next_line_start }
  end

  def expect_fitted_with(fitted_layout, layout, left, top)
    expect(fitted_layout.layout).to eq(layout)
    expect(fitted_layout.left).to eq(left)
    expect(fitted_layout.top).to eq(top)
  end
end
