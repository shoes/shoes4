require 'shoes/spec_helper'

describe Shoes::Dimensions do

  let(:left) {10}
  let(:top) {20}
  let(:width) {100}
  let(:height) {150}
  let(:parent) {double 'parent', width: 200, height: 250, left: 5, top: 12,
                                 absolute_left: 25, absolute_top: 35}
  subject {Shoes::Dimensions.new parent, left, top, width, height}

  describe 'initialization' do
    describe 'without arguments (defaults)' do
      subject {Shoes::Dimensions.new parent}

      its(:left) {should eq 0}
      its(:top) {should eq 0}
      its(:width) {should eq nil}
      its(:height) {should eq nil}
      its(:absolutely_positioned?) {should be_false}
      its(:absolute_x_position?) {should be_false}
      its(:absolute_y_position?) {should be_false}
      its(:margin)      {should == [0, 0, 0, 0]}
      its(:margin_left) {should == 0}
      its(:margin_top) {should == 0}
      its(:margin_right) {should == 0}
      its(:margin_bottom) {should == 0}
      its(:actual_width) {should == nil}
      its(:actual_height) {should == nil}
    end

    describe 'with 2 arguments' do
      subject {Shoes::Dimensions.new parent, left, top}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq nil}
      its(:height) {should eq nil}
      its(:absolutely_positioned?) {should be_true}
      its(:absolute_x_position?) {should be_true}
      its(:absolute_y_position?) {should be_true}
    end

    describe 'with 4 arguments' do
      subject {Shoes::Dimensions.new parent, left, top, width, height}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}
      its(:actual_width) {should == width}
      its(:actual_height) {should == height}
    end

    describe 'with relative width and height' do
      subject {Shoes::Dimensions.new parent, left, top, 0.5, 0.5}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should be_within(1).of 0.5 * parent.width}
      its(:height) {should be_within(1).of 0.5 * parent.height}

      describe 'width/height change of the parent' do
        let(:parent) {Shoes::Dimensions.new nil, left, top, width, height}

        # note that here the first assertion/call is necessary as otherwise
        # the subject will only lazily get initialized after the parent width
        # is already adjusted and therefore wrong impls WILL PASS the tests
        # (jay for red/green/refactor :-) )
        it 'adapts width' do
          subject.width.should be_within(1).of 0.5 * parent.width
          parent.width = 700
          subject.width.should be_within(1).of 350
        end

        it 'adapts height' do
          subject.height.should be_within(1).of 0.5 * parent.height
          parent.height = 800
          subject.height.should be_within(1).of 400
        end
      end
    end

    describe 'with percentages' do
      describe 'with whole integers' do
        subject {Shoes::Dimensions.new parent, left, top, "50%", "50%"}
        its(:width) {should be_within(1).of 0.5 * parent.width}
        its(:height) {should be_within(1).of 0.5 * parent.height}
      end

      describe 'with floats' do
        subject {Shoes::Dimensions.new parent, left, top, "50.0%", "50.00%"}
        its(:width) {should be_within(1).of 0.5 * parent.width}
        its(:height) {should be_within(1).of 0.5 * parent.height}
      end

      describe 'with negatives' do
        subject {Shoes::Dimensions.new parent, left, top, "-10.0%", "-10.00%"}
        its(:width) {should be_within(1).of 0.9 * parent.width}
        its(:height) {should be_within(1).of 0.9 * parent.height}
      end

      describe 'with invalid strings' do
        subject {Shoes::Dimensions.new parent, left, top, "boo", "hoo"}
        its(:width) {should be_nil}
        its(:height) {should be_nil}
      end

      describe 'with padded strings' do
        subject {Shoes::Dimensions.new parent, left, top, "  50 %  ", "\t- 50 %\n"}
        its(:width) {should be_within(1).of 0.5 * parent.width}
        its(:height) {should be_within(1).of 0.5 * parent.height}
      end
    end

    describe 'with negative width and height' do
      let(:width) { -50 }
      let(:height) { -50 }
      subject {Shoes::Dimensions.new parent, left, top, width, height}

      its(:width) {should eq parent.width + width}
      its(:height) {should eq parent.height + height}
    end

    describe 'with relative negative width and height' do
      let(:width) {-0.2}
      let(:height) {-0.2}

      its(:width) {should be_within(1).of 0.8 * parent.width}
      its(:height) {should be_within(1).of 0.8 * parent.height}
    end

    describe 'with a hash' do
      subject { Shoes::Dimensions.new parent, left:   left,
                                              top:    top,
                                              width:  width,
                                              height: height }

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}
      its(:absolutely_positioned?) {should be_true}
      its(:absolute_x_position?) {should be_true}
      its(:absolute_y_position?) {should be_true}

      context 'missing width' do
        subject { Shoes::Dimensions.new parent, left:   left,
                                                top:    top,
                                                height: height }

        its(:width) {should eq nil}
      end
    end

    describe 'absolute_left and _top' do
      its(:absolute_left) {should eq nil}
      its(:absolute_top) {should eq nil}
    end

    describe 'absolute extra values' do
      it 'has an appropriate absolute_right' do
        subject.absolute_left = 10
        subject.absolute_right.should eq width + 10
      end

      it 'has an appropriate absolute_bottom' do
        subject.absolute_top = 15
        subject.absolute_bottom.should eq height + 15
      end
    end
  end

  describe 'setters' do
    it 'also has a setter for left' do
      subject.left = 66
      subject.left.should eq 66
    end
  end

  describe 'centered (e.g. left and top are seen as coords for the center)' do
    describe '5 arguments' do
      subject {Shoes::Dimensions.new parent, 100, 50, 40, 20, :center => true}

      its(:left) {should eq 80}
      its(:top) {should eq 40}
      its(:right) {should eq 120}
      its(:bottom) {should eq 60}
      its(:width) {should eq 40}
      its(:height) {should eq 20}

      it 'reacts to a width change' do
        subject.left.should == 80
        subject.width = 100
        subject.left.should == 50
      end

      it 'reacts to a height change' do
        subject.top.should == 40
        subject.height = 40
        subject.top.should == 30
      end
    end

    describe 'hash' do
      subject {Shoes::Dimensions.new parent, left:   100,
                                     top:    50,
                                     width:  40,
                                     height: 20,
                                     center: true }

      its(:left) {should eq 80}
      its(:top) {should eq 40}
      its(:right) {should eq 120}
      its(:bottom) {should eq 60}
      its(:width) {should eq 40}
      its(:height) {should eq 20}
    end
  end

  describe 'additional dimension methods' do
    its(:right) {should eq left + width}
    its(:bottom) {should eq top + height}

    describe 'without height and width' do
      let(:width) {nil}
      let(:height) {nil}
      its(:right) {should eq left}
      its(:bottom) {should eq top}
    end
  end

  describe 'in_bounds?' do
    describe 'absolute position same as offset' do
      before :each do
        subject.absolute_left = left
        subject.absolute_top  = top
      end

      it {should be_in_bounds 30, 40}
      it {should be_in_bounds left, top}
      it {should be_in_bounds left + width, top + height}
      it {should_not be_in_bounds 0, 0}
      it {should_not be_in_bounds 0, 40}
      it {should_not be_in_bounds 40, 0}
      it {should_not be_in_bounds 200, 50}
      it {should_not be_in_bounds 80, 400}
      it {should_not be_in_bounds 1000, 1000}
    end

    describe 'with absolute position differing from relative' do
      before :each do
        subject.absolute_left = 150
        subject.absolute_top  = 50
      end

      it {should_not be_in_bounds 30, 40}
      it {should_not be_in_bounds left, top}
      it {should_not be_in_bounds 149, 75}
      it {should be_in_bounds 200, 50}
      it {should be_in_bounds 150, 50}
      it {should be_in_bounds 150 + width, 50 + height}
      it {should_not be_in_bounds 80, 400}
    end
  end

  describe 'absolute positioning' do
    subject {Shoes::Dimensions.new parent}
    its(:absolutely_positioned?) {should be_false}

    describe 'changing left' do
      before :each do
        subject.left = left
      end

      its(:absolute_x_position?) {should be_true}
      its(:absolute_y_position?) {should be_false}
      its(:absolutely_positioned?) {should be_true}
    end

    describe 'changing top' do
      before :each do
        subject.top = top
      end

      its(:absolute_x_position?) {should be_false}
      its(:absolute_y_position?) {should be_true}
      its(:absolutely_positioned?) {should be_true}
    end
  end

  describe 'margins' do
    describe 'creation with single margin value' do
      let(:margin) {13}
      subject {Shoes::Dimensions.new parent, width: width, height: height,
                                             margin: margin}

      its(:margin)      {should == [margin, margin, margin, margin]}
      its(:margin_left) {should == margin}
      its(:margin_top) {should == margin}
      its(:margin_right) {should == margin}
      its(:margin_bottom) {should == margin}
      its(:actual_width) {should == width + 2 * margin}
      its(:actual_height) {should == height + 2 * margin}

      it 'adapts margin when one of the margins is changed' do
        subject.margin_right = 7
        subject.margin.should == [margin, margin, 7, margin]
      end
    end

    describe 'creation with all distinct margin values' do
      let(:margin_left) {1}
      let(:margin_top) {7}
      let(:margin_right) {11}
      let(:margin_bottom) {17}

      shared_examples_for 'all distinct margins' do
        its(:margin){should == [margin_left, margin_top, margin_right, margin_bottom]}
        its(:margin_left) {should == margin_left}
        its(:margin_top) {should == margin_top}
        its(:margin_right) {should == margin_right}
        its(:margin_bottom) {should == margin_bottom}
        its(:actual_width) {should == width + margin_left + margin_right}
        its(:actual_height) {should == height + margin_top + margin_bottom}
      end

      describe 'setting margins separetely through hash' do
        subject {Shoes::Dimensions.new parent, width: width,
                                               height: height,
                                               margin_left: margin_left,
                                               margin_top: margin_top,
                                               margin_right: margin_right,
                                               margin_bottom: margin_bottom}
        it_behaves_like 'all distinct margins'
      end

      describe 'setting margins through margin array' do
        subject {Shoes::Dimensions.new parent,
                                       width: width,
                                       height: height,
                                       margin: [margin_left, margin_top,
                                                margin_right, margin_bottom]}
        it_behaves_like 'all distinct margins'
      end
    end
  end

  describe Shoes::AbsoluteDimensions do
    subject {Shoes::AbsoluteDimensions.new left, top, width, height}
    it 'has the same absolute_left as left' do
      subject.absolute_left.should eq left
    end

    it 'has the same absolute_top as top' do
      subject.absolute_top.should eq top
    end

    describe 'not adapting floats to parent values' do
      subject {Shoes::AbsoluteDimensions.new left, top, 1.04, 2.10}
      it 'does not adapt width' do
        subject.width.should be_within(0.01).of 1.04
      end

      it 'does not adapt height' do
        subject.height.should be_within(0.01).of 2.10
      end
    end
  end
  
  describe Shoes::ParentDimensions do
    describe 'takes parent values if not specified' do
      subject {Shoes::ParentDimensions.new parent}

      its(:left) {should eq parent.left}
      its(:top) {should eq parent.top}
      its(:width) {should eq parent.width}
      its(:height) {should eq parent.height}
      its(:absolute_left) {should eq parent.absolute_left}
      its(:absolute_top) {should eq parent.absolute_top}
    end

    describe 'otherwise it takes its own values' do
      subject {Shoes::ParentDimensions.new parent, left, top, width, height}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}
    end
  end
end

describe Shoes::DimensionsDelegations do

  describe 'with a DSL class and a dimensions method' do
    let(:dimensions) {double('dimensions')}

    class DummyClass
      include Shoes::DimensionsDelegations
      def dimensions
      end
    end

    subject do
      dummy = DummyClass.new
      dummy.stub dimensions: dimensions
      dummy
    end

    it 'forwards left calls to dimensions' do
      dimensions.should_receive :left
      subject.left
    end

    it 'forwards bottom calls to dimensions' do
      dimensions.should_receive :bottom
      subject.bottom
    end

    it 'forwards setter calls like left= do dimensions' do
      dimensions.should_receive :left=
      subject.left = 66
    end

    it 'forwards absolutely_positioned? calls to the dimensions' do
      dimensions.should_receive :absolutely_positioned?
      subject.absolutely_positioned?
    end
  end

  describe 'with any backend class that has a defined dsl method' do
    let(:dsl){double 'dsl'}

    class AnotherDummyClass
      include Shoes::BackendDimensionsDelegations
      def dsl
      end
    end

    subject do
      dummy = AnotherDummyClass.new
      dummy.stub dsl: dsl
      dummy
    end

    it 'forwards calls to dsl' do
      dsl.should_receive :left
      subject.left
    end
  end

end
