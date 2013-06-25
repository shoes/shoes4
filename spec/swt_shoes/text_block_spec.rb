require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  let(:opts) { {justify: true, leading: 10} }
  let(:font) { ::Swt::Graphics::Font.new }
  let(:parent) { Shoes::Flow.new app_real, app_real }
  let(:textcursor) { double("text cursor", move: move_textcursor) }
  let(:move_textcursor) { double("move text cursor", show: true) }
  let(:dsl) { double("dsl", parent: parent, app: parent.app, text: "hello world", opts: opts, left: 0, top: 10,
    width: 200, height: 180, font: "font", font_size: 16, margin_left: 0, margin_top: 0, cursor: -1, textcursor: textcursor) }
  let(:app) { parent.app.gui.real }
  let(:app_real) { Shoes::App.new }
  let(:container) { app }
  subject {
    Shoes::Swt::TextBlock.new(dsl, opts)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::TextBlock) }
  end

  it_behaves_like "paintable"
  it_behaves_like "movable text", 10, 20

  it "redraws the container" do
    container.should_receive(:redraw)
    subject.redraw
  end

  describe "text block painter" do
    let(:text_layout) { double("text layout", getLocation: Shoes::Point.new(0, 0)).as_null_object }
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc").as_null_object }
    subject { Shoes::Swt::TextBlock::TbPainter.new(dsl, opts) }

    before :each do
      ::Swt::TextLayout.stub(:new) { text_layout }
      #::Swt::Font.stub(:new)
    end

    it "sets text" do
      text_layout.should_receive(:setText).with(dsl.text)
      subject.paintControl(event)
    end

    it "sets width" do
      text_layout.should_receive(:setWidth).with(dsl.width)
      subject.paintControl(event)
    end

    it "draws" do
      text_layout.should_receive(:draw).with(gc, dsl.left, dsl.top)
      subject.paintControl(event)
    end

    it "sets justify" do
      text_layout.should_receive(:setJustify).with(opts[:justify])
      subject.paintControl(event)
    end

    it "sets spacing" do
      text_layout.should_receive(:setSpacing).with(opts[:leading])
      subject.paintControl(event)
    end

    it "sets alignment" do
      text_layout.should_receive(:setAlignment).with(anything)
      subject.paintControl(event)
    end

    it "sets text styles" do
      text_layout.should_receive(:setStyle).with(anything, anything, anything).at_least(1).times
      subject.paintControl(event)
    end
  end
end
