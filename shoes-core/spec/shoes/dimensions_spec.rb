require 'shoes/spec_helper'

describe Shoes::Dimensions do

  let(:parent_left) {left}
  let(:parent_top) {top}
  let(:parent_width) {width}
  let(:parent_height) {height}
  let(:parent) {Shoes::AbsoluteDimensions.new parent_left, parent_top, parent_width, parent_height}

  let(:left) {10}
  let(:top) {20}
  let(:width) {100}
  let(:height) {150}
  let(:right) {17}
  let(:bottom) {23}
  let(:opts) { {} }
  subject {Shoes::Dimensions.new parent, left, top, width, height, opts}

  shared_context 'margins' do
    let(:margin_left) {3}
    let(:margin_top) {5}
    let(:margin_right) {7}
    let(:margin_bottom) {11}
    let(:opts) { {margin_left: margin_left, margin_top: margin_top,
                  margin_right: margin_right, margin_bottom: margin_bottom } }
  end

  shared_context 'element dimensions set' do
    let(:element_width) {43}
    let(:element_height) {29}

    before :each do
      subject.element_width = element_width
      subject.element_height = element_height
    end
  end

  ONE_PIXEL = 1 unless const_defined?(:ONE_PIXEL) && ONE_PIXEL == 1

  describe 'initialization' do
    include InspectHelpers

    describe 'without arguments (defaults)' do
      subject {Shoes::Dimensions.new parent}

      its(:left) {should be_nil}
      its(:top) {should be_nil}
      its(:width) {should eq nil}
      its(:height) {should eq nil}
      its(:absolutely_positioned?) {should be_falsey}
      its(:absolute_x_position?) {should be_falsey}
      its(:absolute_y_position?) {should be_falsey}
      its(:absolute_left_position?) {should be_falsey}
      its(:absolute_top_position?) {should be_falsey}
      its(:absolute_right_position?) {should be_falsey}
      its(:absolute_bottom_position?) {should be_falsey}
      its(:margin)      {should == [0, 0, 0, 0]}
      its(:margin_left) {should == 0}
      its(:margin_top) {should == 0}
      its(:margin_right) {should == 0}
      its(:margin_bottom) {should == 0}
      its(:element_width) {should == nil}
      its(:element_height) {should == nil}
      its(:to_s) {should == "(Shoes::Dimensions)"}
      its(:inspect) {should match(/[(]Shoes::Dimensions:#{shoes_object_id_pattern} relative:[(]_,_[)]->[(]_,_[)] absolute:[(]_,_[)]->[(]_,_[)] _x_[)]/)}
    end

    describe 'with 2 arguments' do
      subject {Shoes::Dimensions.new parent, left, top}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq nil}
      its(:height) {should eq nil}
      its(:absolutely_positioned?) {should be_truthy}
      its(:absolute_x_position?) {should be_truthy}
      its(:absolute_y_position?) {should be_truthy}
      its(:absolute_left_position?) {should be_truthy}
      its(:absolute_top_position?) {should be_truthy}
      its(:absolute_right_position?) {should be_falsey}
      its(:absolute_bottom_position?) {should be_falsey}
      its(:inspect) {should match(/[(]Shoes::Dimensions:#{shoes_object_id_pattern} relative:[(]#{left},#{top}[)]->[(]_,_[)] absolute:[(]_,_[)]->[(]_,_[)] _x_[)]/)}
    end

    describe 'with 4 arguments' do
      subject {Shoes::Dimensions.new parent, left, top, width, height}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}
      its(:element_width) {should == width}
      its(:element_height) {should == height}
      its(:inspect) {should match(/[(]Shoes::Dimensions:#{shoes_object_id_pattern} relative:[(]#{left},#{top}[)]->[(]_,_[)] absolute:[(]_,_[)]->[(]_,_[)] #{width}x#{height}[)]/)}
    end

    describe 'with relative width and height' do
      subject {Shoes::Dimensions.new parent, left, top, 0.5, 0.5}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should be_within(ONE_PIXEL).of 0.5 * parent.width}
      its(:height) {should be_within(ONE_PIXEL).of 0.5 * parent.height}

      describe 'width/height change of the parent' do

        # note that here the first assertion/call is necessary as otherwise
        # the subject will only lazily get initialized after the parent width
        # is already adjusted and therefore wrong impls WILL PASS the tests
        # (jay for red/green/refactor :-) )
        it 'adapts width' do
          expect(subject.width).to be_within(ONE_PIXEL).of 0.5 * parent.width
          parent.width = 700
          expect(subject.width).to be_within(ONE_PIXEL).of 350
        end

        it 'adapts height' do
          expect(subject.height).to be_within(ONE_PIXEL).of 0.5 * parent.height
          parent.height = 800
          expect(subject.height).to be_within(ONE_PIXEL).of 400
        end
      end

      describe 'a parent with margins' do
        let(:parent) {Shoes::AbsoluteDimensions.new parent_left,
                                                    parent_top,
                                                    parent_width,
                                                    parent_height,
                                                    margin: 20}
        subject {Shoes::Dimensions.new parent, left, top, 1.0, 1.0}

        it 'uses the element_width to calculate its own relative width' do
          expect(subject.width).to eq parent.element_width
        end

        it 'has a smaller width than the parent element (due to margins)' do
          expect(subject.width).to be < parent.width
        end

        its(:height) {should eq parent.element_height}
      end

    end

    describe 'with percentages' do
      describe 'with whole integers' do
        subject {Shoes::Dimensions.new parent, left, top, "50%", "50%"}
        its(:width) {should be_within(ONE_PIXEL).of 0.5 * parent.width}
        its(:height) {should be_within(ONE_PIXEL).of 0.5 * parent.height}
      end

      describe 'with floats' do
        subject {Shoes::Dimensions.new parent, left, top, "50.0%", "50.00%"}
        its(:width) {should be_within(ONE_PIXEL).of 0.5 * parent.width}
        its(:height) {should be_within(ONE_PIXEL).of 0.5 * parent.height}
      end

      describe 'with negatives' do
        subject {Shoes::Dimensions.new parent, left, top, "-10.0%", "-10.00%"}
        its(:width) {should be_within(ONE_PIXEL).of 0.9 * parent.width}
        its(:height) {should be_within(ONE_PIXEL).of 0.9 * parent.height}
      end

      describe 'with padded strings' do
        subject {Shoes::Dimensions.new parent, left, top, "  50 %  ", "\t- 50 %\n"}
        its(:width) {should be_within(ONE_PIXEL).of 0.5 * parent.width}
        its(:height) {should be_within(ONE_PIXEL).of 0.5 * parent.height}
      end
    end

    describe 'with strings' do
      describe 'with integer strings' do
        subject {Shoes::Dimensions.new parent, "22", "20", "10", "10"}

        its(:left) {should eq 22}
        its(:top) {should eq 20}
        its(:width) {should eq 10}
        its(:height) {should eq 10}
      end

      describe 'with strings px' do
        subject {Shoes::Dimensions.new parent, "10px", "10px", "0px", "100px"}

        its(:left) {should eq 10}
        its(:top) {should eq 10}
        its(:width) {should eq 0}
        its(:height) {should eq 100}
      end

      describe 'white space with px is also ok' do
        subject {Shoes::Dimensions.new parent, "10 px", "20   px", "30px", "55  px"}

        its(:left) {should eq 10}
        its(:top) {should eq 20}
        its(:width) {should eq 30}
        its(:height) {should eq 55}
      end

      describe 'with invalid integer strings' do
        subject {Shoes::Dimensions.new parent, "p100px", "Hell0", "hell0", "glob"}

        its(:left) {should be_nil}
        its(:top) {should be_nil}
        its(:width) {should be_nil}
        its(:height) {should be_nil}
      end

      describe 'with negative values' do
        let(:parent_width) {200}
        let(:parent_height) {300}
        subject {Shoes::Dimensions.new parent, "- 100", "-20px", "- 50px", "- 80"}

        its(:left) {should eq -100}
        its(:top) {should eq -20}
        its(:width) {should eq (parent_width - 50)}
        its(:height) {should eq (parent_height - 80)}
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

      its(:width) {should be_within(ONE_PIXEL).of 0.8 * parent.width}
      its(:height) {should be_within(ONE_PIXEL).of 0.8 * parent.height}
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
      its(:absolutely_positioned?) {should be_truthy}
      its(:absolute_x_position?) {should be_truthy}
      its(:absolute_y_position?) {should be_truthy}

      context 'missing width' do
        subject { Shoes::Dimensions.new parent, left:   left,
                                                top:    top,
                                                height: height }

        its(:width) {should eq nil}
      end

      describe 'with right and bottom' do
        subject {Shoes::Dimensions.new parent, right: right, bottom: bottom}

        its(:right) {should eq right}
        its(:bottom) {should eq bottom}
        its(:absolute_x_position?) {should be_truthy}
        its(:absolute_y_position?) {should be_truthy}
        its(:absolute_left_position?) {should be_falsey}
        its(:absolute_top_position?) {should be_falsey}
        its(:absolute_right_position?) {should be_truthy}
        its(:absolute_bottom_position?) {should be_truthy}
      end
    end

    describe 'absolute_left and _top' do
      its(:absolute_left) {should eq nil}
      its(:absolute_top) {should eq nil}
      it {is_expected.not_to be_positioned}
    end

    describe 'absolute extra values' do
      let(:absolute_left) {7}
      let(:absolute_top) {13}

      before :each do
        subject.absolute_left = absolute_left
        subject.absolute_top  = absolute_top
      end

      # in case you wonder about the -1... say left is 20 and we have a width of
      # 100 then the right must be 119, because you have to take pixel number 20
      # into account so 20..119 is 100 while 20..120 is 101. E.g.:
      # (20..119).size => 100
      it 'has an appropriate absolute_right' do
        expect(subject.absolute_right).to eq width + absolute_left - ONE_PIXEL
      end

      it 'has an appropriate absolute_bottom' do
        expect(subject.absolute_bottom).to eq height + absolute_top - ONE_PIXEL
      end

      it 'has an element left which is the same' do
        expect(subject.element_left).to eq subject.absolute_left
      end

      it 'has an element top which is the same' do
        expect(subject.element_top).to eq subject.absolute_top
      end

      it 'considers itself positioned' do
        expect(subject.positioned?).to be_truthy
      end

      describe 'with margins' do
        include_context 'margins'
        include_context 'element dimensions set'

        it 'adjusts element_left' do
          expect(subject.element_left).to eq subject.absolute_left + margin_left
        end

        it 'adjusts element_top' do
          expect(subject.element_top).to eq subject.absolute_top + margin_top
        end

        it 'returns an element_right' do
          expect(subject.element_right).to eq subject.element_left +
                                                  element_width - ONE_PIXEL
        end

        it 'returns an element_bottom' do
          expect(subject.element_bottom).to eq subject.element_top +
                                                   element_height - ONE_PIXEL
        end
      end
    end
  end


  describe 'setting ' do
    it 'has a setter for left' do
      subject.left = 66
      expect(subject.left).to eq 66
    end

    it 'has a setter for right' do
      subject.right = 77
      expect(subject.right).to eq 77
    end

    it 'has a setter for bottom' do
      subject.bottom = 87
      expect(subject.bottom).to eq 87
    end

    describe 'element_*' do
      include_context 'element dimensions set'

      it 'sets width to that value' do
        expect(subject.width).to eq element_width
      end

      it 'responds that value for element_width' do
        expect(subject.element_width).to eq element_width
      end

      it 'sets height to that value' do
        expect(subject.height).to eq element_height
      end

      it 'sets element_height to that value' do
        expect(subject.element_height).to eq element_height
      end

      it 'can set element_width to nil' do
        subject.element_width = nil
        expect(subject.element_width).to eq nil
      end

      it 'can set element_height to nil' do
        subject.element_height = nil
        expect(subject.element_height).to eq nil
      end

      describe 'with margins' do
        include_context 'margins'

        it 'sets width to element_width plus margins' do
          expect(subject.width).to eq margin_left + element_width + margin_right
        end

        it 'sets height to element_height plus margins' do
          expect(subject.height).to eq margin_top + element_height + margin_bottom
        end

        it 'sets that value for element_width' do
          expect(subject.element_width).to eq element_width
        end

        it 'sets element_height to that value' do
          expect(subject.element_height).to eq element_height
        end
      end
    end
  end

  describe 'centered (e.g. left and top are seen as coords for the center)' do
    describe '5 arguments' do
      subject {Shoes::Dimensions.new parent, 100, 50, 40, 20, :center => true}

      its(:left) {should eq 80}
      its(:top) {should eq 40}
      its(:width) {should eq 40}
      its(:height) {should eq 20}

      it 'reacts to a width change' do
        expect(subject.left).to eq(80)
        subject.width = 100
        expect(subject.left).to eq(50)
      end

      it 'reacts to a height change' do
        expect(subject.top).to eq(40)
        subject.height = 40
        expect(subject.top).to eq(30)
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
      its(:width) {should eq 40}
      its(:height) {should eq 20}
    end
  end

  describe 'additional dimension methods' do
    describe 'without height and width' do
      let(:width) {nil}
      let(:height) {nil}
    end
  end

  describe 'in_bounds?' do

    let(:left) {10}
    let(:top) {20}
    let(:width) {100}
    let(:height) {150}

    describe 'absolute position same as offset' do
      before :each do
        subject.absolute_left = left
        subject.absolute_top  = top
      end

      it {is_expected.to be_in_bounds 30, 40}
      it {is_expected.to be_in_bounds left, top}
      it {is_expected.to be_in_bounds left + width - ONE_PIXEL,
                              top + height - ONE_PIXEL}
      it {is_expected.not_to be_in_bounds left + width, top + height}
      it {is_expected.not_to be_in_bounds 30, top + height}
      it {is_expected.not_to be_in_bounds left + width, 40}
      it {is_expected.not_to be_in_bounds 0, 0}
      it {is_expected.not_to be_in_bounds 0, 40}
      it {is_expected.not_to be_in_bounds 40, 0}
      it {is_expected.not_to be_in_bounds 200, 50}
      it {is_expected.not_to be_in_bounds 80, 400}
      it {is_expected.not_to be_in_bounds 1000, 1000}
    end

    describe 'with absolute position differing from relative' do
      let(:absolute_left) {150}
      let(:absolute_top) {50}

      before :each do
        subject.absolute_left = absolute_left
        subject.absolute_top  = absolute_top
      end

      it {is_expected.not_to be_in_bounds 30, 40}
      it {is_expected.not_to be_in_bounds left, top}
      it {is_expected.not_to be_in_bounds 149, 75}
      it {is_expected.to be_in_bounds 200, absolute_top}
      it {is_expected.to be_in_bounds absolute_left, absolute_top}
      it {is_expected.to be_in_bounds absolute_left + width - ONE_PIXEL,
                              absolute_top + height - ONE_PIXEL
      }
      it {is_expected.not_to be_in_bounds 80, 400}
    end
  end

  describe 'absolute positioning' do
    subject {Shoes::Dimensions.new parent}
    its(:absolutely_positioned?) {should be_falsey}

    shared_examples_for 'absolute_x_position' do
      its(:absolute_x_position?) {should be_truthy}
      its(:absolute_y_position?) {should be_falsey}
      its(:absolutely_positioned?) {should be_truthy}
    end

    describe 'changing left' do
      before :each do subject.left = left end
      it_behaves_like 'absolute_x_position'
    end

    describe 'chaning right' do
      before :each do subject.right = right end
      it_behaves_like 'absolute_x_position'
    end

    shared_examples_for 'absolute_y_position' do
      its(:absolute_x_position?) {should be_falsey}
      its(:absolute_y_position?) {should be_truthy}
      its(:absolutely_positioned?) {should be_truthy}
    end

    describe 'changing top' do
      before :each do subject.top = top end
      it_behaves_like 'absolute_y_position'
    end

    describe 'changing bottom' do
      before :each do subject.bottom = bottom end
      it_behaves_like 'absolute_y_position'
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
      its(:width) {should == width}
      its(:height) {should == height}
      its(:element_width) {should == width - 2 * margin}
      its(:element_height) {should == height - 2 * margin}

      it 'adapts margin when one of the margins is changed' do
        subject.margin_right = 7
        expect(subject.margin).to eq([margin, margin, 7, margin])
      end
      
      it 'adapts margins when margin is changed with single value' do
        subject.margin = 7
        expect(subject.margin).to eq([7, 7, 7, 7])
      end
      
      it 'adapts margin when margin is changed with array' do
        subject.margin = [7, 7, 7, 7]
        expect(subject.margin).to eq([7, 7, 7, 7])
      end
    end

    describe 'creation with all distinct margin values' do
      let(:margin_left) {3}
      let(:margin_top) {7}
      let(:margin_right) {11}
      let(:margin_bottom) {17}

      shared_examples_for 'all distinct margins' do
        its(:margin){should == [margin_left, margin_top, margin_right, margin_bottom]}
        its(:margin_left) {should == margin_left}
        its(:margin_top) {should == margin_top}
        its(:margin_right) {should == margin_right}
        its(:margin_bottom) {should == margin_bottom}
        its(:width) {should == width}
        its(:height) {should == height}
        its(:element_width) {should == width - (margin_left + margin_right)}
        its(:element_height) {should == height - (margin_top + margin_bottom)}
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

  describe 'displace' do

    before :each do
      # need to have a rough positon
      subject.absolute_left = 0
      subject.absolute_top  = 0
    end

    describe 'displace_left' do
      let(:displace_left) {3}
      it 'modifies the value of element_left' do
        expect do
          subject.displace_left = displace_left
        end.to change{subject.element_left}.by(displace_left)
      end

      it 'does not modify the value of absolute_left' do
        expect do
          subject.displace_left = displace_left
        end.not_to change {subject.absolute_left}
      end

      context 'via opts' do
        subject { Shoes::Dimensions.new(nil, 0, 0, 0, 0, displace_left: 10)}
        it 'modifies element_left' do
          expect(subject.element_left).to eql(10)
        end
      end
    end

    describe 'displace_top' do
      let(:displace_top) {7}

      it 'modifies the value of element_top' do
        expect do
          subject.displace_top = displace_top
        end.to change{subject.element_top}.by(displace_top)
      end

      it 'does not modify the value of absolute_top' do
        expect do
          subject.displace_top = displace_top
        end.not_to change {subject.absolute_top}
      end

      context 'via opts' do
        subject { Shoes::Dimensions.new(nil, 0, 0, 0, 0, displace_top: 10)}
        it 'modifies element_top' do
          expect(subject.element_top).to eql(10)
        end
      end
    end

  end

  it {is_expected.to be_takes_up_space}

  describe 'left/top/right/bottom not set so get them relative to parent' do
    let(:parent) {double 'parent', x_dimension: x_dimension,
                                   y_dimension: y_dimension}

    let(:x_dimension) {double 'parent x dimension', element_start: parent_left,
                                                    element_end: parent_right}
    let(:y_dimension) {double 'parent y dimension', element_start: parent_top,
                                                    element_end: parent_bottom}
    let(:parent_right) {parent_left + 20}
    let(:parent_bottom) {parent_top + 30}

    let(:width) {3}
    let(:height) {5}

    subject {Shoes::Dimensions.new parent, width: width, height: height}

    describe 'positioned at the start' do
      before :each do
        # there is no setter for element_* but with no margin it's the same
        subject.absolute_left = parent_left
        subject.absolute_top = parent_top
      end

      its(:left) {should eq 0}
      its(:top) {should eq 0}
      its(:right) {should eq parent_right - subject.element_right}
      its(:bottom) {should eq parent_bottom - subject.element_bottom}
    end

    describe 'positioned with an offset' do
      TEST_OFFSET = 7

      before :each do
        subject.absolute_left = parent_left + TEST_OFFSET
        subject.absolute_top = parent_top + TEST_OFFSET
      end

      its(:left) {should eq TEST_OFFSET}
      its(:top) {should eq TEST_OFFSET}
      its(:right) {should eq parent_right - subject.element_right}
      its(:bottom) {should eq parent_bottom - subject.element_bottom}
    end
  end

  describe Shoes::AbsoluteDimensions do
    subject {Shoes::AbsoluteDimensions.new left, top, width, height}
    describe 'not adapting floats to parent values' do
      subject {Shoes::AbsoluteDimensions.new left, top, 1.04, 2.10}
      it 'does not adapt width' do
        expect(subject.width).to be_within(0.01).of 1.04
      end

      it 'does not adapt height' do
        expect(subject.height).to be_within(0.01).of 2.10
      end
    end
  end

  describe Shoes::ParentDimensions do
    describe 'takes some parent values if not specified' do
      let(:parent) {Shoes::Dimensions.new nil, parent_left, parent_top,
                                          parent_width, parent_height,
                                          margin: 20}
      subject {Shoes::ParentDimensions.new parent}

      its(:left)   {should eq parent.left}
      its(:top)    {should eq parent.top}
      its(:width)  {should eq parent.width}
      its(:height) {should eq parent.height}

      its(:margin_left)   {should eq 0}
      its(:margin_top)    {should eq 0}
      its(:margin_right)  {should eq 0}
      its(:margin_bottom) {should eq 0}

      context 'with parent absolute_left/top set' do
        before :each do
          parent.absolute_left = left
          parent.absolute_top  = top
        end

        its(:absolute_left) {should eq parent.absolute_left}
        its(:absolute_top)  {should eq parent.absolute_top}
        its(:element_left)  {should eq parent.absolute_left}
        its(:element_top)   {should eq parent.absolute_top}
      end
    end

    describe 'otherwise it takes its own values' do
      subject {Shoes::ParentDimensions.new parent, left, top, width, height}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}

      it 'can also still handle special values like a negative width' do
        subject.width = -10
        expect(subject.width).to eq (parent.width - 10)
      end

      it 'can also still handle special values like a relative height' do
        subject.height = 0.8
        expect(subject.height).to be_within(ONE_PIXEL).of(0.8 * parent.height)
      end
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
      allow(dummy).to receive_messages dimensions: dimensions
      dummy
    end

    it 'forwards left calls to dimensions' do
      expect(dimensions).to receive :left
      subject.left
    end

    it 'forwards bottom calls to dimensions' do
      expect(dimensions).to receive :bottom
      subject.bottom
    end

    it 'forwards setter calls like left= do dimensions' do
      expect(dimensions).to receive :left=
      subject.left = 66
    end

    it 'forwards absolutely_positioned? calls to the dimensions' do
      expect(dimensions).to receive :absolutely_positioned?
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
      allow(dummy).to receive_messages dsl: dsl
      dummy
    end

    it 'forwards calls to dsl' do
      expect(dsl).to receive :left
      subject.left
    end

    it 'does not forward calls to parent' do
      expect(dsl).not_to receive :parent
      expect {subject.parent}.to raise_error
    end
  end

end
