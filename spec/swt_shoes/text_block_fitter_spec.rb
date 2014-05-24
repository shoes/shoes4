require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_fitter'

describe Shoes::Swt::TextBlockFitter do
  let(:dsl) { double('dsl', parent: parent_dsl, text: "Text goes here",
                     absolute_left: 25, absolute_top: 75,
                     desired_width: 85,
                     element_left: 26, element_top: 76,
                     margin_left: 1, margin_top: 1) }

  let(:parent_dsl) { double('parent_dsl', parent: grandparent_dsl,
                            absolute_left: 0, absolute_right: 100,
                            width: parent_width, height: 200) }

  let(:grandparent_dsl) { double('grandparent_dsl', parent: app,
                                 width: grandparent_width) }

  let(:app) { double('app', width: app_width) }

  let(:parent_width)      { 100 }
  let(:grandparent_width) { 1000 }
  let(:app_width)         { 2000 }

  let(:text_block) { double('text_block', dsl: dsl) }
  let(:layout)     { double('layout') }

  let(:current_position) { double('current_position') }

  subject { Shoes::Swt::TextBlockFitter.new(text_block, current_position) }

  before(:each) do
    Shoes::Swt::FittedTextLayout.stub(:new) { layout }
  end

  describe "determining available space" do
    it "should offset by parent with current position" do
      when_positioned_at(x: 15, y: 5, next_line_start: 30)
      expect(subject.available_space).to eq([85, 24])
    end

    it "should move to next line with at very end of vertical space" do
      when_positioned_at(x: 15, y: 5, next_line_start: 5)
      expect(subject.available_space).to eq([85, :unbounded])
    end

    it "should move to next line when top is past the projected next line" do
      when_positioned_at(x: 15, y: 100, next_line_start: 5)
      expect(subject.available_space).to eq([85, :unbounded])
    end

    context "positioned outside parent" do
      before(:each) do
        dsl.stub(:desired_width) { -1 }
      end

      it "bumps to parent width when at end of vertical space" do
        when_positioned_at(x: 110, y: 5, next_line_start: 5)
        dsl.stub(:desired_width).with(grandparent_width) { 890 }

        expect(subject.available_space).to eq([890, :unbounded])
      end

      it "bumps out until it fits" do
        when_positioned_at(x:1010, y: 5, next_line_start: 5)
        dsl.stub(:desired_width).with(app_width) { 990 }

        expect(subject.available_space).to eq([990, :unbounded])
      end

      it "just gives up if it still won't fit" do
        when_positioned_at(x:1010, y: 5, next_line_start: 5)
        expect(subject.available_space).to eq([0, 0])
      end
    end
  end

  describe "finding what didn't fit" do
    it "should tell split text by offsets and heights" do
      layout = double('layout', line_offsets: [0, 5, 9], text: "Text Split")
      layout.stub(:line_bounds) { double('line_bounds', height: 50)}

      expect(subject.split_text(layout, 55)).to eq(["Text ", "Split"])
    end

    it "should be able to split text when too small" do
      layout = double('layout', line_offsets: [0, 10], text: "Text Split")
      layout.stub(:line_bounds).with(0) { double('line_bounds', height: 21)}
      layout.stub(:line_bounds).with(1) { raise "Boom" }

      expect(subject.split_text(layout, 33)).to eq(["Text Split", ""])
    end
  end

  describe "fit it in" do
    let(:bounds) { double('bounds', width: 100, height: 50)}
    let(:layout) { double('layout', text: "something something",
                          line_count: 1, line_offsets:[], bounds: bounds) }

    before(:each) do
      layout.stub(:position_at) { layout }
    end

    context "to one layout" do
      it "should work" do
        fitted_layouts = when_fit_at(x: 25, y: 75, next_line_start: 130)
        expect_fitted_layouts(fitted_layouts, [26, 76])
      end

      it "with one line, even if height is bigger" do
        bounds.stub(width: 50)
        fitted_layouts = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_fitted_layouts(fitted_layouts, [26, 76])
      end
    end

    context "to two layouts" do
      before(:each) do
        layout.stub(line_count: 2, line_bounds: double(height: 15))
        bounds.stub(width: 50)
        dsl.stub(containing_width: :unused)
      end

      it "should split text and overflow to second layout" do
        with_text_split("something ", "something")
        expect(layout).to receive(:dispose).once

        fitted_layouts = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_fitted_layouts(fitted_layouts, [26, 76], [1, 126])
      end

      it "should overflow all text to second layout" do
        with_text_split("", "something something")
        expect(layout).to receive(:dispose).once

        fitted_layouts = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_fitted_layouts(fitted_layouts, [26, 76], [1, 95])
      end
    end

    context "to empty first layout" do
      before(:each) do
        dsl.stub(containing_width: 100)
        layout.stub(:text= => nil)
      end

      it "rolls to second layout when 0 remaining width" do
        dsl.stub(desired_width: 0)
        fitted_layouts = when_fit_at(x: 0, y: 75, next_line_start: 95)
        expect_fitted_layouts(fitted_layouts, [26, 76], [1, 96])
      end

      it "rolls to second layout when negative remaining width" do
        dsl.stub(desired_width: -1)
        fitted_layouts = when_fit_at(x: 0, y: 75, next_line_start: 95)
        expect_fitted_layouts(fitted_layouts, [26, 76], [1, 96])
      end
    end
  end

  def with_text_split(first, second)
    dsl.stub(text: first + second)
    layout.stub(line_offsets: [0, first.length, first.length + second.length])
  end

  def when_positioned_at(args)
    x = args.fetch(:x)
    y = args.fetch(:y)
    next_line_start = args.fetch(:next_line_start)

    dsl.stub(absolute_left: x, absolute_top: y)
    current_position.stub(:next_line_start) { next_line_start }
  end

  def when_fit_at(args)
    when_positioned_at(args)
    subject.fit_it_in
  end

  def expect_fitted_layouts(fitted_layouts, *coordinates)
    fitted_layouts.each_with_index do |fitted, index|
      x, y = coordinates[index]
      expect(fitted).to have_received(:position_at).with(x, y)
    end
  end
end
