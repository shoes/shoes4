require "shoes/spec_helper"

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Button do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {:width => 131, :height => 137, :margin => 143} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app: app }

  subject { Shoes::Button.new(parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"

  it { should respond_to :click }
  it { should respond_to :focus }

  describe "initialize" do
    it "should set accessors", :no_swt do
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

    shared_examples "stacked" do
      specify "returns self", :no_swt do
        subject.positioning(x, y, max).should be(subject)
      end

      specify "top == max.top + max.height", :no_swt do
        subject.positioning(x, y, max)
        subject.top.should eq(155)
      end
    end

    shared_examples_for "left-aligned" do
      specify "subject receives :move" do
        subject.should_receive(:_move).with(0, 155)
        subject.positioning(x, y, max)
      end

      specify "left == parent.left" do
        subject.positioning(x, y, max)
        subject.left.should eq(0)
      end
    end

    shared_examples_for "right-aligned" do
      specify "left position is measured from right edge of parent", :no_swt do
        subject.positioning(x, y, max)
        subject.left.should eq(final_x)
      end
    end

    shared_examples_for "flowed" do
      specify "top == max.top" do
        subject.positioning(x, y, max)
        subject.top.should eq(100)
      end
    end

    shared_examples "tall element" do
      specify "element taller than max", :no_swt do
        max.height.should be < subject.height
      end

      specify "returns self", :no_swt do
        subject.positioning(x, y, max).should be(subject)
      end
    end

    shared_examples "short element" do
      specify "max.height > subject.height" do
        max.height.should be > subject.height
      end

      specify "returns max" do
        subject.positioning(x, y, max).should be(max)
      end
    end

    shared_context "@right" do
      let(:final_x) { 134 }
      before :each do
        # Ugly, but not implemented (no other way to set the ivar)
        subject.instance_variable_set(:@right, 35)
      end
    end

    shared_context "tall parent" do
      let(:max) { double("max", :top => 100, :height => 200) }
    end

    context "parent is not a flow" do
      let(:parent) { Shoes::Stack.new app, app: app }

      before :each do
        subject.parent.is_a?(Shoes::Flow).should be_false
        parent.stub(:width) { 300 }
      end

      context "@right is nil" do
        it_behaves_like "stacked"
        it_behaves_like "left-aligned"
      end

      context "@right defined" do
        include_context "@right"
        it_behaves_like "stacked"
        it_behaves_like "right-aligned"

        specify "subject receives :move", :no_swt do
          subject.should_receive(:_move).with(134, 155)
          subject.positioning(x, y, max)
        end
      end
    end

    context "parent is a flow, but element doesn't fit" do
      before :each do
        parent.stub(:is_a?) { true }
        parent.stub(:width) { 150 }
        subject.parent.is_a?(Shoes::Flow).should be_true
        element_fits?(x, subject.width, parent.left, parent.width)
      end

      it_behaves_like "stacked"
    end

    context "parent is a flow and element fits" do
      let(:x) { 10 }

      before :each do
        parent.stub(:is_a?) { true }
        parent.stub(:width) { 300 }
        subject.parent.is_a?(Shoes::Flow).should be_true
        element_fits?(x, subject.width, parent.left, parent.width).should be_true
      end

      context "@right defined" do
        include_context "@right"

        it_behaves_like "right-aligned"
        it_behaves_like "flowed"

        specify "receives :move", :no_swt do
          subject.should_receive(:_move).with(final_x, max.top)
          subject.positioning(x, y, max)
        end

        context "short parent" do
          it_behaves_like "tall element"
        end

        context "tall parent" do
          include_context "tall parent"
          it_behaves_like "short element"
        end
      end

      context "element has nil @right" do
        it_behaves_like "flowed"

        specify "receives :move" do
          subject.should_receive(:_move).with(x, max.top)
          subject.positioning(x, y, max)
        end

        specify "left == x" do
          subject.positioning(x, y, max)
          subject.left.should eq(x)
        end

        context "short parent" do
          it_behaves_like "tall element"
        end

        context "tall parent" do
          include_context "tall parent"
          it_behaves_like "short element"
        end
      end
    end
  end
end

def element_fits?(element_left, element_width, parent_left, parent_width)
  element_left + element_width <= parent_left + parent_width
end

