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

    context "second branch" do
      specify "parent is not a flow" do
        subject.parent.is_a?(Shoes::Flow).should be_false
      end

      specify "returns self" do
        subject.positioning(x, y, max).should be(subject)
      end
    end

    context "first branch" do
      let(:x) { 10 }

      before :each do
        parent.stub(:is_a?) { true }
        parent.stub(:width) { 300 }
      end

      specify "parent is a flow" do
        subject.parent.is_a?(Shoes::Flow).should be_true
      end

      specify "element fits" do
        (x + subject.width).should be < (parent.left + parent.width)
      end

      describe "element has @right" do
        let(:final_x) { 134 }
        before :each do
          # FIXME: UGLY, but not implemented (no other way to set the ivar)
          subject.instance_variable_set(:@right, 35)
          subject.should_receive(:move).with(final_x, max.top)
          subject.positioning(x, y, max)
        end

        specify "left position is measured from right edge of parent" do
          subject.left.should eq(final_x)
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

      end

      describe "height branch" do
        context "max height < height" do
          specify "max.height < height" do
            max.height.should be < subject.height
          end

          specify "returns self" do
            subject.positioning(x, y, max).should be(subject)
          end
        end

        context "max.height > height" do
          let(:max) { double("max", :top => 100, :height => 200) }

          specify "max.height > height" do
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
