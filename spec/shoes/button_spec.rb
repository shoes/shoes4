require "shoes/spec_helper"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143} }
  let(:parent) { double("parent", real: nil, gui: nil, add_child: nil ) }

  subject { Shoes::Button.new(parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"

  describe "initialize" do
    before :each do
      Shoes::Mock::Button.any_instance.stub(:real) { mock( size:
        mock(x: 131, y: 137) ) }
    end

    it "should set accessors" do
      button = subject
      button.parent.should == parent
      button.blk.should == input_block
      button.text.should == "text"
      button.width.should == 131
      button.height.should == 137
    end
  end

  describe "positioning" do
    let(:max) { double("max", :top => 100, :height => 55) }
    let(:x) { 40 }
    let(:y) { 80 }

    before :each do
      parent.stub(:left) { 0 }
    end

    shared_examples "element goes below" do
      specify "returns self" do
        subject.positioning(x, y, max).should be(subject)
      end

      specify "top == max.top + max.height" do
        subject.positioning(x, y, max)
        subject.top.should eq(155)
      end
    end

    shared_examples_for "left-aligned" do
      specify "subject receives :move" do
        subject.should_receive(:move).with(0, 155)
        subject.positioning(x, y, max)
      end

      specify "left == parent.left" do
        subject.positioning(x, y, max)
        subject.left.should eq(0)
      end
    end

    shared_examples_for "right-aligned" do
      specify "subject receives :move" do
        subject.should_receive(:move).with(0, 42)
        subject.positioning(x, y, max)
      end

      specify "element positioned from parent's right" do

      end
    end

    shared_context "@right" do
      let(:final_x) { 134 }
      before :each do
        # Ugly, but not implemented (no other way to set the ivar)
        subject.instance_variable_set(:@right, 35)
      end
    end

    context "parent is not a flow" do
      before :each do
        subject.parent.is_a?(Shoes::Flow).should be_false
        parent.stub(:width) { 300 }
      end

      context "@right is nil" do
        it_behaves_like "element goes below"
        it_behaves_like "left-aligned"
      end

      context "@right defined" do
        include_context "@right"
        it_behaves_like "element goes below"
      end

    end

    context "parent is a flow, but element doesn't fit" do
      before :each do
        parent.stub(:is_a?) { true }
        parent.stub(:width) { 150 }
        subject.parent.is_a?(Shoes::Flow).should be_true
        element_fits?(x, subject.width, parent.left, parent.width)
      end

      it_behaves_like "element goes below"
    end

    context "parent is a flow and element fits" do
      let(:x) { 10 }

      before :each do
        parent.stub(:is_a?) { true }
        parent.stub(:width) { 300 }
        subject.parent.is_a?(Shoes::Flow).should be_true
        element_fits?(x, subject.width, parent.left, parent.width).should be_true
      end

      describe "@right defined" do
        include_context "@right"

        specify "receives :move" do
          subject.should_receive(:move).with(final_x, max.top)
          subject.positioning(x, y, max)
        end

        specify "left position is measured from right edge of parent" do
          subject.positioning(x, y, max)
          subject.left.should eq(final_x)
        end

        specify "top == max.top" do
          subject.positioning(x, y, max)
          subject.top.should eq(100)
        end
      end

      describe "element has nil @right" do
        before :each do
          subject.should_receive(:move).with(x, max.top)
          subject.positioning(x, y, max)
        end

        specify "left == x" do
          subject.left.should eq(x)
        end

        specify "top == max.top" do
          subject.top.should eq(100)
        end
      end

      describe "height branch" do
        context "max height < height" do
          before :each do
            max.height.should be < subject.height
          end

          specify "returns self" do
            subject.positioning(x, y, max).should be(subject)
          end
        end

        context "max.height > height" do
          let(:max) { double("max", :top => 100, :height => 200) }

          before :each do
            max.height.should be > subject.height
          end

          specify "returns max" do
            subject.positioning(x, y, max).should be(max)
          end
        end
      end
    end
  end
end

def element_fits?(element_left, element_width, parent_left, parent_width)
  element_left + element_width <= parent_left + parent_width
end

