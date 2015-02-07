require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextBlock::Fitter do
  let(:dsl) { double('dsl', parent: parent_dsl, text: "Text goes here",
                     desired_width: 85, centered?:    false,
                     absolute_left: 25, absolute_top: 75,
                     element_left:  26, element_top:  76,
                     margin_left:   1,  margin_top:   1) }

  let(:parent_dsl) { double('parent_dsl', parent: grandparent_dsl,
                            absolute_top: 0, absolute_left: 0, absolute_right: 100,
                            width: parent_width, height: 200) }

  let(:grandparent_dsl) { double('grandparent_dsl', parent: app,
                                 width: grandparent_width) }

  let(:app) { double('app', width: app_width) }

  let(:parent_width)      { 100 }
  let(:grandparent_width) { 1000 }
  let(:app_width)         { 2000 }

  let(:text_block) { double('text_block', dsl: dsl) }
  let(:segment)    { double('segment') }

  let(:current_position) { double('current_position') }

  subject { Shoes::Swt::TextBlock::Fitter.new(text_block, current_position) }

  before(:each) do
    allow(Shoes::Swt::TextBlock::TextSegment).to receive(:new) { segment }
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
        allow(dsl).to receive(:desired_width) { -1 }
      end

      it "bumps to parent width when at end of vertical space" do
        when_positioned_at(x: 110, y: 5, next_line_start: 5)
        allow(dsl).to receive(:desired_width).with(grandparent_width) { 890 }

        expect(subject.available_space).to eq([890, :unbounded])
      end

      it "bumps out until it fits" do
        when_positioned_at(x:1010, y: 5, next_line_start: 5)
        allow(dsl).to receive(:desired_width).with(app_width) { 990 }

        expect(subject.available_space).to eq([990, :unbounded])
      end

      it "just gives up if it still won't fit" do
        when_positioned_at(x:1010, y: 5, next_line_start: 5)
        expect(subject.available_space).to eq([0, 0])
      end
    end
  end

  describe "finding what didn't fit" do
    it "splits when one line past requested height" do
      segment = double('segment', line_offsets: [0, 5, 10], text: "Text Split")
      allow(segment).to receive(:line_bounds) { double('line_bounds', height: 25)}

      expect(subject.split_text(segment, 24)).to eq(["Text ", "Split"])
    end

    it "should be able to split text when too small" do
      segment = double('segment', line_offsets: [0, 10], text: "Text Split")
      allow(segment).to receive(:line_bounds).with(0) { double('line_bounds', height: 21)}
      allow(segment).to receive(:line_bounds).with(1) { raise "Boom" }

      expect(subject.split_text(segment, 33)).to eq(["Text Split", ""])
    end
  end

  describe "fit it in" do
    let(:bounds) { double('bounds', width: 100, height: 50)}
    let(:segment) { double('segment',
                           text: "something something", :text= => nil,
                           line_count: 1, line_offsets:[], bounds: bounds) }

    before(:each) do
      layout = double('swt_layout', :spacing => 4, :spacing= => nil)
      allow(segment).to receive(:position_at) { segment }
      allow(segment).to receive(:spacing) { 4 }
      allow(segment).to receive(:layout)  { layout }

    end

    context "to one segment" do
      it "should work" do
        segments = when_fit_at(x: 25, y: 75, next_line_start: 130)
        expect_segments(segments, [26, 76])
      end

      it "with one line, even if height is bigger" do
        allow(bounds).to receive_messages(width: 50)
        segments = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_segments(segments, [26, 76])
      end
    end

    context "to two segments" do
      before(:each) do
        allow(segment).to receive_messages(line_count: 2, line_bounds: double(height: 15))
        allow(bounds).to receive_messages(width: 50)
        allow(dsl).to receive_messages(containing_width: :unused)
      end

      it "should split text and overflow to second segment" do
        with_text_split("something ", "something")
        expect(segment).to receive(:dispose).once

        segments = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_segments(segments, [26, 76], [1, 123])
      end

      it "should overflow all text to second segment" do
        with_text_split("", "something something")
        expect(segment).to receive(:dispose).once

        segments = when_fit_at(x: 25, y: 75, next_line_start: 95)
        expect_segments(segments, [26, 76], [1, 96])
      end
    end

    context "to empty first segment" do
      before(:each) do
        allow(dsl).to receive_messages(containing_width: 100)
        expect(segment).to receive(:fill_background=).with(true)
      end

      it "rolls to second segment when 0 remaining width" do
        allow(dsl).to receive_messages(desired_width: 0)
        segments = when_fit_at(x: 0, y: 75, next_line_start: 95)
        expect_segments(segments, [26, 76], [1, 96])
      end

      it "rolls to second segment when negative remaining width" do
        allow(dsl).to receive_messages(desired_width: -1)
        segments = when_fit_at(x: 0, y: 75, next_line_start: 95)
        expect_segments(segments, [26, 76], [1, 96])
      end
    end

    context "to center segment" do
      before do
        allow(dsl).to receive_messages(centered?: true)
        allow(dsl).to receive_messages(containing_width: 100)
      end

      it "uses full width" do
        allow(dsl).to receive_messages(element_left: 0, left: 0)
        segments = when_fit_at(x: 0, y: 75, next_line_start: 95)
        expect_segments(segments, [0, 76])
      end

      it "bumps down a line if not at start" do
        allow(dsl).to receive_messages(element_left: 20, left: 20)
        segments = when_fit_at(x: 20, y: 75, next_line_start: 95)
        expect_segments(segments, [20, 76], [1, 95])
      end

      it "if unbounded height, still bumps down properly" do
        allow(dsl).to receive_messages(absolute_top: 95, element_left: 20, left: 20, margin_left: 1)
        segments = when_fit_at(x: 20, y: 75, next_line_start: 95)
        expect_segments(segments, [20, 76], [1, 95])
      end
    end

    context "doesn't fit" do
      it "with no width and unbounded height" do
        allow(dsl).to receive_messages(desired_width: 0)
        segments = when_fit_at(x: 0, y: 0, next_line_start: 0)
        expect(segments).to be_empty
      end

      it "with no width and 0 height" do
        allow(dsl).to receive_messages(desired_width: 0, containing_width: 0)
        segments = when_fit_at(x: 0, y: 0, next_line_start: 1)
        expect(segments).to be_empty
      end
    end
  end

  def with_text_split(first, second)
    allow(dsl).to receive_messages(text: first + second)
    allow(segment).to receive_messages(line_offsets: [0, first.length, first.length + second.length])
  end

  def when_positioned_at(args)
    x = args.fetch(:x)
    y = args.fetch(:y)
    next_line_start = args.fetch(:next_line_start)

    allow(dsl).to receive_messages(absolute_left: x, absolute_top: y)
    allow(current_position).to receive(:next_line_start) { next_line_start }
  end

  def when_fit_at(args)
    when_positioned_at(args)
    subject.fit_it_in
  end

  def expect_segments(segments, *coordinates)
    segments.each_with_index do |segment, index|
      x, y = coordinates[index]
      expect(segment).to have_received(:position_at).with(x, y)
    end
  end
end
