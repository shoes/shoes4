require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  let(:opts) { {justify: true, leading: 10, underline: "single"} }
  let(:font) { ::Swt::Graphics::Font.new }
  let(:parent) { Shoes::Flow.new app_real, app_real }
  let(:textcursor) { double("text cursor", move: move_textcursor) }
  let(:move_textcursor) { double("move text cursor", show: true) }
  let(:dsl) { double("dsl", parent: parent, app: parent.app, text: "hello world",
                     opts: opts, element_width: 200, element_height: 180,
                     element_left: 0, element_top: 10,  font: "font",
                     font_size: 16, margin_left: 0, margin_top: 0, cursor: -1,
                     textcursor: textcursor, 
					 text_styles: {}, :hidden? => false).as_null_object
            }
  let(:app) { parent.app.gui.real }
  let(:app_real) { Shoes::App.new }
  let(:container) { app }
  subject {
    Shoes::Swt::TextBlock.new(dsl)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::TextBlock) }
  end

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like "movable text", 10, 20

  it "redraws the container" do
    container.should_receive(:redraw)
    subject.redraw
  end

  it 'responds to click' do
    expect(subject).to respond_to :click
  end

  describe "text block painter" do
    let(:text_layout) { double("text layout", getLocation: Shoes::Point.new(0, 0)).as_null_object }
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc").as_null_object }
    let(:style) { double(:style) }
    subject { Shoes::Swt::TextBlockPainter.new(dsl) }

    before :each do
      ::Swt::TextLayout.stub(:new) { text_layout }
      ::Swt::TextStyle.stub(:new) { style.as_null_object }
      #::Swt::Font.stub(:new)
    end

    it "sets text" do
      text_layout.should_receive(:setText).with(dsl.text)
      subject.paintControl(event)
    end

    it "sets width" do
      text_layout.should_receive(:setWidth).with(dsl.element_width)
      subject.paintControl(event)
    end

    it "draws" do
      text_layout.should_receive(:draw).with(gc, dsl.element_left, dsl.element_top)
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

    context "rise option" do
      it "sets default rise value to nil" do
        style.should_receive(:rise=).with(nil)
        subject.paintControl(event)
      end

      it "sets correct rise value" do
        opts[:rise] = 10
        style.should_receive(:rise=).with(10)

        subject.paintControl(event)
      end
    end

    context "underline option" do
      it "sets default underline style to none" do
        opts.delete(:underline)

        style.should_receive(:underline=).with(false)
        style.should_receive(:underlineStyle=).with(nil)

        subject.paintControl(event)
      end

      it "sets correct underline style" do

        style.should_receive(:underline=).with(true)
        style.should_receive(:underlineStyle=).with(Shoes::Swt::TextStyleFactory::UNDERLINE_STYLES["single"])

        subject.paintControl(event)
      end

      it "sets underline color" do
        opts[:undercolor] = Shoes::Color.new(0, 0, 255)
        swt_color = ::Swt::Color.new(Shoes.display, 0, 0, 255)

        style.should_receive(:underlineColor=).with(swt_color)

        subject.paintControl(event)
      end

      it "sets default underline color to nil" do
        style.should_receive(:underlineColor=).with(nil)

        subject.paintControl(event)
      end
    end

    context "strikethrough option" do
      it "sets default strikethrough to none" do
        style.should_receive(:strikeout=).with(false)

        subject.paintControl(event)
      end

      it "sets strikethrough" do
        opts[:strikethrough] = "single"

        style.should_receive(:strikeout=).with(true)

        subject.paintControl(event)
      end

      it "sets strikethrough color" do
        opts[:strikecolor] = Shoes::Color.new(0, 0, 255)
        swt_color = ::Swt::Color.new(Shoes.display, 0, 0, 255)

        style.should_receive(:strikeoutColor=).with(swt_color)

        subject.paintControl(event)
      end

      it "sets default strikethrough color to nil" do
        style.should_receive(:strikeoutColor=).with(nil)

        subject.paintControl(event)
      end
    end

    context "font styles" do
      it "sets font style to bold" do
        opts[:weight] = true
        ::Swt::Font.should_receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD)
        subject.paintControl(event)
      end

      it "sets font style to italic" do
        opts[:emphasis] = true
        ::Swt::Font.should_receive(:new).with(anything, anything, anything, ::Swt::SWT::ITALIC)
        subject.paintControl(event)
      end

      it "sets font style to both bold and italic" do
        opts[:weight] = true
        opts[:emphasis] = true
        ::Swt::Font.should_receive(:new).with(anything, anything, anything, ::Swt::SWT::BOLD | ::Swt::SWT::ITALIC)

        subject.paintControl(event)
      end

      it "sets font style to normal by default" do
        ::Swt::Font.should_receive(:new).with(anything, anything, anything, ::Swt::SWT::NORMAL)

        subject.paintControl(event)
      end
    end

    context "colors" do
      let(:black) { ::Swt::Color.new Shoes.display, 0, 0, 0 }
      let(:salmon) { Shoes::Swt::Color.new(Shoes::COLORS[:salmon]).real }

      describe "stroke" do
        it "is black by default" do
          ::Swt::TextStyle.should_receive(:new).with(anything, black, anything)
          subject.paintControl(event)
        end

        it "is set with opts[:stroke]" do
          opts[:stroke] = Shoes::COLORS[:salmon]
          ::Swt::TextStyle.should_receive(:new).with(anything, salmon, anything)
          subject.paintControl(event)
        end
      end

      describe "fill" do
        it "is nil by default" do
          ::Swt::TextStyle.should_receive(:new).with(anything, anything, nil)
          subject.paintControl(event)
        end

        it "is set with opts[:fill]" do
          opts[:fill] = Shoes::COLORS[:salmon]
          ::Swt::TextStyle.should_receive(:new).with(anything, anything, salmon)
          subject.paintControl(event)
        end
      end
    end

    context "with text fragments" do

      let(:black) { ::Swt::Color.new Shoes.display, 0, 0, 0 }
      let(:white) { ::Swt::Color.new Shoes.display, 255, 255, 255 }
      let(:font) { ::Swt::Graphics::Font.new Shoes.display, "Arial", 12, ::Swt::SWT::NORMAL }

      it "creates a text style" do
        pending "creative testing energy"
        ::Swt::TextStyle.should_receive(:new).exactly(42).times
        subject.paintControl(event)
      end
    end
  end
end
