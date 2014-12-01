require 'shoes/swt/spec_helper'

describe Shoes::Swt::TextBlock::Painter do
  include_context "swt app"

  let(:dsl_style) { {justify: true, leading: 10, underline: "single"} }
  let(:gui) { double("gui", dispose: nil) }
  let(:dsl) { double("dsl", app: shoes_app, gui: gui,
                     text: text, cursor: nil, style: dsl_style,
                     element_width: 200, element_height: 180,
                     element_left: 0, element_top: 10, font: "font",
                     size: 16, margin_left: 0, margin_top: 0,
                     text_styles: text_styles, :hidden? => false).as_null_object
            }

  let(:segment) do
    allow(::Swt::Font).to receive(:new)       { font }
    allow(::Swt::TextLayout).to receive(:new) { text_layout }
    allow(::Swt::TextStyle).to receive(:new)  { style }

    Shoes::Swt::TextBlock::TextSegment.new(dsl, text, 200).position_at(0, 10)
  end

  let(:text_layout) { double("text layout", text: text).as_null_object }

  let(:event) { double("event").as_null_object }
  let(:style) { double(:style).as_null_object }
  let(:font)  { double(:font, font_data: [font_data]).as_null_object }
  let(:font_data) { double(name: "font", height: 16.0, style: ::Swt::SWT::NORMAL) }

  let(:blue) { Shoes::Color.new(0, 0, 255) }
  let(:swt_blue) { Shoes::Swt::Color.new(blue).real}
  let(:text_styles) {{}}
  let(:text) {'hello world'}

  subject { Shoes::Swt::TextBlock::Painter.new(dsl) }

  before :each do
    allow(::Swt::TextStyle).to receive(:new)  { style.as_null_object }

    # Can't stub this in during initial let because of circular reference
    # segments -> dsl -> gui -> segments...
    allow(gui).to receive_messages(segments: [segment])
  end

  it "draws" do
    expect(segment).to receive(:draw)
    subject.paintControl(event)
  end

  it "sets justify" do
    expect(text_layout).to receive(:justify=).with(dsl_style[:justify])
    subject.paintControl(event)
  end

  it "sets spacing" do
    expect(text_layout).to receive(:spacing=).with(dsl_style[:leading])
    subject.paintControl(event)
  end

  it "sets alignment" do
    expect(text_layout).to receive(:alignment=).with(anything)
    subject.paintControl(event)
  end

  it "sets text styles" do
    expect(text_layout).to receive(:set_style).with(anything, anything, anything).at_least(1).times
    subject.paintControl(event)
  end

  context "rise option" do
    it "sets default rise value to nil" do
      expect(style).to receive(:rise=).with(nil)
      subject.paintControl(event)
    end

    it "sets correct rise value" do
      dsl_style[:rise] = 10
      expect(style).to receive(:rise=).with(10)

      subject.paintControl(event)
    end
  end

  context "underline option" do
    it "sets default underline style to none" do
      dsl_style.delete(:underline)

      expect(style).to receive(:underline=).with(false)
      expect(style).to receive(:underlineStyle=).with(nil)

      subject.paintControl(event)
    end

    it "sets correct underline style" do

      expect(style).to receive(:underline=).with(true)
      expect(style).to receive(:underlineStyle=).with(Shoes::Swt::TextStyleFactory::UNDERLINE_STYLES["single"])

      subject.paintControl(event)
    end

    it "sets underline color" do
      dsl_style[:undercolor] = blue

      expect(style).to receive(:underlineColor=).with(swt_blue)

      subject.paintControl(event)
    end

    it "sets default underline color to nil" do
      expect(style).to receive(:underlineColor=).with(nil)

      subject.paintControl(event)
    end
  end

  context "strikethrough option" do
    it "sets default strikethrough to none" do
      expect(style).to receive(:strikeout=).with(false)

      subject.paintControl(event)
    end

    it "sets strikethrough" do
      dsl_style[:strikethrough] = "single"

      expect(style).to receive(:strikeout=).with(true)

      subject.paintControl(event)
    end

    it "sets strikethrough color" do
      dsl_style[:strikecolor] = blue

      expect(style).to receive(:strikeoutColor=).with(swt_blue)

      subject.paintControl(event)
    end

    it "sets default strikethrough color to nil" do
      expect(style).to receive(:strikeoutColor=).with(nil)

      subject.paintControl(event)
    end
  end

  context "font styles" do
    it "sets font style to bold" do
      dsl_style[:weight] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD)
      subject.paintControl(event)
    end

    it "sets font style to italic" do
      dsl_style[:emphasis] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::ITALIC)
      subject.paintControl(event)
    end

    it "sets font style to both bold and italic" do
      dsl_style[:weight] = true
      dsl_style[:emphasis] = true
      expect(::Swt::Font).to receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD | ::Swt::SWT::ITALIC)

      subject.paintControl(event)
    end
  end

  context "colors" do
    let(:black) { Shoes::Swt::Color.new(Shoes::COLORS[:black]).real }
    let(:salmon) { Shoes::Swt::Color.new(Shoes::COLORS[:salmon]).real }

    describe "stroke" do
      it "is black by default" do
        expect(::Swt::TextStyle).to receive(:new).with(anything, black, anything)
        subject.paintControl(event)
      end

      it "is set with dsl_style[:stroke]" do
        dsl_style[:stroke] = Shoes::COLORS[:salmon]
        expect(::Swt::TextStyle).to receive(:new).with(anything, salmon, anything)
        subject.paintControl(event)
      end
    end

    describe "fill" do
      it "is nil by default" do
        expect(::Swt::TextStyle).to receive(:new).with(anything, anything, nil)
        subject.paintControl(event)
      end

      it "is set with dsl_style[:fill]" do
        dsl_style[:fill] = Shoes::COLORS[:salmon]
        expect(::Swt::TextStyle).to receive(:new).with(anything, anything, salmon)
        subject.paintControl(event)
      end
    end
  end

  describe 'text_styles' do
    # this text_styles relies a lot on the internal structure of TextBlock/Painter
    # right now, which I'm not too fond of... :)
    let(:text_styles) {[[0...text.length, [Shoes::Span.new([text], size: 50)]]]}
    it 'sets the font size to 50' do
      expect(::Swt::Font).to receive(:new).
                             with(anything, anything, 50, anything)

      subject.paintControl event
    end
  end
end
