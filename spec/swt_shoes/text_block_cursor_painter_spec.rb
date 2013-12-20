require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_cursor_painter'

describe Shoes::Swt::TextBlockCursorPainter do
  let(:app) { double("app", black: double("black")) }
  let(:dsl) { double("dsl", app: app, textcursor: textcursor) }
  let(:textcursor) { double("textcursor") }
  let(:fitted_layouts) { [] }

  subject { Shoes::Swt::TextBlockCursorPainter.new(dsl, fitted_layouts) }

  describe "missing cursor" do
    before(:each) do
      dsl.stub(:cursor) { nil }
      dsl.stub(:textcursor=)
      textcursor.stub(:remove)
      textcursor.stub(:textcursor=)
    end

    it "shouldn't do anything without text cursor" do
      dsl.stub(:textcursor) { nil}
      subject.draw
      expect(dsl).to_not have_received(:textcursor=)
    end

    it "should remove leftover text cursor" do
      subject.draw
      expect(dsl).to have_received(:textcursor=)
      expect(textcursor).to have_received(:remove)
    end
  end

  describe "cursor positioning" do
    let(:left) { 10 }
    let(:top)  { 20 }
    let(:position) { double(x: 5, y: 5) }
    let(:line_height) { 10 }
    let(:first_layout) { double("first layout", text: "first",
                                get_location: position,
                                left: left, top: top, line_height: line_height) }
    let(:second_layout) { double("second layout", text: "second",
                                 get_location: position,
                                 left: left, top: top + 100, line_height: line_height) }

    before(:each) do
      textcursor.stub(:move)
      textcursor.stub(:show)

      fitted_layouts << first_layout
      fitted_layouts << second_layout
    end

    it "should choose the first layout" do
      position_cursor(0)
      expect(subject.choose_layout).to eq(first_layout)
      expect(subject.relative_cursor).to eq(0)
    end

    it "should choose first layout at very end" do
      cursor = first_layout.text.length
      position_cursor(cursor)
      expect(subject.choose_layout).to eq(first_layout)
      expect(subject.relative_cursor).to eq(cursor)
    end

    it "should choose the second layout" do
      position_cursor(first_layout.text.length + 1)
      expect(subject.choose_layout).to eq(second_layout)
      expect(subject.relative_cursor).to eq(1)
    end

    it "should chooose the second layout for -1" do
      position_cursor(-1)
      expect(subject.choose_layout).to eq(second_layout)
      expect(subject.relative_cursor).to eq(second_layout.text.length)
    end

    it "should allow crazy positions past the end" do
      position_cursor(1_000)
      expect(subject.choose_layout).to eq(second_layout)
      expect(subject.relative_cursor).to eq(second_layout.text.length)
    end

    it "should move within first layout" do
      position_cursor(1)
      subject.draw
      expect(textcursor).to have_received(:move).with(left + position.x,
                                                      top + position.y)
      expect(textcursor).to have_received(:show)
    end

    it "should move within second layout" do
      position_cursor(-1)
      subject.draw
      expect(textcursor).to have_received(:move).with(left + position.x,
                                                      top + 100 + position.y)
      expect(textcursor).to have_received(:show)
    end

    def position_cursor(index)
      dsl.stub(:cursor) { index }
    end
  end

  describe "textcursor management" do
    before(:each) do
      dsl.stub(:textcursor=)
    end

    it "should create textcursor if missing" do
      dsl.stub(:textcursor) { nil }
      app.stub(:line).and_return(textcursor)

      result = subject.textcursor(0)
      expect(result).to eq(textcursor)
      expect(dsl).to have_received(:textcursor=).with(textcursor)
    end

    it "should just return textcursor if already there" do
      result = subject.textcursor(0)
      expect(result).to eq(textcursor)
      expect(dsl).to_not have_received(:textcursor=)
    end
  end

end
