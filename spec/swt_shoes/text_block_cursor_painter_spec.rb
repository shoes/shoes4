require 'swt_shoes/spec_helper'
require 'shoes/swt/text_block_cursor_painter'

describe Shoes::Swt::TextBlockCursorPainter do
  include_context "swt app"

  let(:dsl) { double("dsl", app: shoes_app, textcursor: textcursor, has_textcursor?: true) }
  let(:textcursor) { double("textcursor", left:0, top: 0) }
  let(:text_layout) { double("text layout",
                             get_line_bounds: double("line bounds", height: 10)) }
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
      dsl.stub(:has_textcursor?) { nil}
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
    let(:first_layout) { double("first layout", text: "first",
                                get_location: position,
                                get_line_bounds: text_layout, height: 10,
                                element_left: left, element_top: top) }

    before(:each) do
      textcursor.stub(:move)
      textcursor.stub(:show)
      dsl.stub(:text).and_return(first_layout.text)
      fitted_layouts << first_layout
    end

    context "with one layout" do
      it "should choose the layout" do
        position_cursor(0)
        expect(subject.choose_layout).to eq(first_layout)
        expect(subject.relative_cursor).to eq(0)
      end

      it "should choose layout at very end" do
        cursor = first_layout.text.length
        position_cursor(cursor)
        expect(subject.choose_layout).to eq(first_layout)
        expect(subject.relative_cursor).to eq(cursor)
      end

      it "should choose the layout when just past end" do
        position_cursor(first_layout.text.length + 1)
        expect_cursor_at_end_of(first_layout)
      end

      it "should chooose the layout for -1" do
        position_cursor(-1)
        expect_cursor_at_end_of(first_layout)
      end

      it "should choose right past end" do
        position_cursor(first_layout.text.length + 3)
        expect_cursor_at_end_of(first_layout)
      end

      it "should allow crazy positions past the end" do
        position_cursor(1_000)
        expect_cursor_at_end_of(first_layout)
      end
    end

    context "with two layouts" do
      let(:second_layout) { double("second layout", text: "second",
                                   get_location: position,
                                   element_left: left, element_top: top + 100) }
      before(:each) do
        dsl.stub(:text).and_return(first_layout.text + second_layout.text)
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
        expect_cursor_at_end_of(second_layout)
      end

      it "should allow crazy positions past the end" do
        position_cursor(1_000)
        expect_cursor_at_end_of(second_layout)
      end

      context "when moving" do
        before :each do
          subject.stub(:cursor_height) { 12 }
        end

        context "in the first layout" do
          before :each do
            position_cursor(1)
          end

          it "moves" do
            subject.draw
            expect(textcursor).to have_received(:move).with(left + position.x,
                                                            top + position.y)
            expect(textcursor).to have_received(:show)
          end

          it "does not move when already in position" do
            textcursor.stub(:left) { left + position.x }
            textcursor.stub(:top)  { top + position.y }
            subject.stub(:move_textcursor)

            subject.draw

            expect(subject).to_not have_received(:move_textcursor)
          end
        end

        context "in the second layout" do
          before :each do
            position_cursor(-1)
          end

          it "moves" do
            subject.draw
            expect(textcursor).to have_received(:move).with(left + position.x,
                                                            top + 100 + position.y)
            expect(textcursor).to have_received(:show)
          end

          it "does not move when already in position" do
            textcursor.stub(:left) { left + position.x }
            textcursor.stub(:top)  { top + 100 + position.y }
            subject.stub(:move_textcursor)

            subject.draw

            expect(subject).to_not have_received(:move_textcursor)
          end
        end
      end
    end

    def position_cursor(index)
      dsl.stub(:cursor) { index }
    end

    def expect_cursor_at_end_of(layout)
      expect(subject.choose_layout).to eq(layout)
      expect(subject.relative_cursor).to eq(layout.text.length)
    end
  end

  describe "textcursor management" do
    let(:first_layout) { double("first layout", layout: text_layout) }

    before(:each) do
      shoes_app.stub(:textcursor)
      fitted_layouts << first_layout
    end

    it "delegates to dsl" do
      dsl.stub(:textcursor) { textcursor }
      result = subject.textcursor
      expect(result).to eq(textcursor)
    end
  end
end
