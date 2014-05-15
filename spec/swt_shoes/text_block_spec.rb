require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  include_context "swt app"

  let(:height) { 100 }
  let(:width)  { 200 }
  let(:margin) { 10 }
  let(:dsl) { double("dsl", app: shoes_app, text: "text",
                     margin_left: 0, margin_right: 0,
                     margin_top: 0, margin_bottom: 0).as_null_object }

  subject { Shoes::Swt::TextBlock.new(dsl) }

  it_behaves_like "paintable"
  it_behaves_like "togglable"

  # reported nil, caused trouble in simple-downloader.rb
  it 'initially responds with empty fitted layouts' do
    expect(subject.fitted_layouts).to be_empty
  end

  describe "bounds checking" do
    it "delegates to fitted layout" do
      layout = double()
      subject.fitted_layouts = [layout]
      expect(layout).to receive(:in_bounds?)

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
    let(:fitted_layout) { create_layout }
    let(:second_fitted_layout) { create_layout }

    let(:current_position) { Shoes::Slot::CurrentPosition.new(0, 0) }

    before(:each) do
      ::Shoes::Swt::TextBlockFitter.stub(:new) { fitter }
      fitter.stub(:fit_it_in).and_return([fitted_layout], [second_fitted_layout])
    end

    describe "with single layout" do
      before(:each) do
        dsl.stub(:absolute_left)   { 50 }
        dsl.stub(:absolute_top)    { 0 }
        dsl.stub(:absolute_bottom) { layout_height }
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
        dsl.stub(:text) { "text\n" }

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

      it "should not dispose any layouts" do
        expect(fitted_layout).not_to receive(:dispose)
        expect(second_fitted_layout).not_to receive(:dispose)

        subject.contents_alignment(current_position)
      end

      context "on the second call" do
        before(:each) do
          subject.contents_alignment(current_position)
        end

        it "should only dispose old fitted layout" do
          expect(fitted_layout).to receive(:dispose)
          expect(second_fitted_layout).not_to receive(:dispose)

          subject.contents_alignment(current_position)
        end

        it "should dispose all layouts on clear" do
          swt_app.stub(:remove_listener)

          expect(fitted_layout).to receive(:dispose).at_least(1).times
          expect(second_fitted_layout).to receive(:dispose).at_least(1).times

          subject.contents_alignment(current_position)
          subject.clear
        end
      end
    end

    describe "with two layouts" do
      before(:each) do
        dsl.stub(:parent) { double("dsl parent", absolute_left: 0) }
        dsl.stub(:absolute_bottom) { layout_height }

        current_position.next_line_start = 0

        fitter.stub(:fit_it_in) {
          [create_layout("unused fitted layout"),
           create_layout("fitted_layout")]
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

  def create_layout(name="fitted layout", width=layout_width,
                    height=layout_height, line_height=line_height)
    bounds = double("bounds", width: width, height: height)
    double(name, disposed?: false,
           width: width, layout_height: height,
           last_line_width: width, last_line_height: line_height,
           bounds: bounds)
  end
end
