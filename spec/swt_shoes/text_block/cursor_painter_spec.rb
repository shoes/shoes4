require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock::CursorPainter do
  include_context "swt app"

  let(:dsl) { double("dsl", app: shoes_app, textcursor: textcursor, has_textcursor?: true) }
  let(:textcursor) { double("textcursor", left:0, top: 0) }
  let(:segment_collection) { double('segment collection',
                                   cursor_height: 12,
                                   relative_text_position: 0)}

  subject { Shoes::Swt::TextBlock::CursorPainter.new(dsl,
                                                     segment_collection) }

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
    let(:first_segment) { double("first segment", text: "first",
                                 get_location: position, height: 10,
                                 element_left: left, element_top: top) }

    before(:each) do
      textcursor.stub(:move)
      textcursor.stub(:show)
    end

    context "with two segments" do
      let(:second_segment) { double("second segment", text: "second",
                                    get_location: position,
                                    element_left: left, element_top: top + 100) }
      before(:each) do
        dsl.stub(:text).and_return(first_segment.text + second_segment.text)
      end

      context "when moving" do
        context "in the first segment" do
          before :each do
            dsl.stub(:cursor) { 1 }
            segment_collection.stub(:segment_at_text_position) { first_segment }
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

        context "in the second segment" do
          before :each do
            dsl.stub(:cursor) { -1 }
            segment_collection.stub(:segment_at_text_position) { second_segment }
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
  end

  describe "textcursor management" do
    before(:each) do
      shoes_app.stub(:textcursor)
    end

    it "delegates to dsl" do
      dsl.stub(:textcursor) { textcursor }
      result = subject.textcursor
      expect(result).to eq(textcursor)
    end
  end
end
