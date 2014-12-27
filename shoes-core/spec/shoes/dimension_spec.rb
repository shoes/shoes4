require 'spec_helper'

describe Shoes::Dimension do

  subject {Shoes::Dimension.new parent_dimension}
  let(:start) {10}
  let(:extent) {21}
  let(:parent_element_start) {34}
  let(:parent_element_end) {83}
  let(:parent_element_extent) {600}
  let(:parent_dimension) { double 'parent_dimension',
                                  element_start:  parent_element_start,
                                  element_end:    parent_element_end,
                                  element_extent: parent_element_extent }

  ONE_PIXEL = 1 unless const_defined?(:ONE_PIXEL) && ONE_PIXEL == 1

  describe 'initialization' do
    describe 'without arguments (even no parent)' do
      subject {Shoes::Dimension.new nil}

      its(:start) {should eq nil}
      its(:end) {should eq nil}
      its(:extent) {should eq nil}
      its(:margin_start) {should eq 0}
      its(:margin_end) {should eq 0}
      its(:displace_start) {should eq 0}
      it {is_expected.not_to be_positioned}
      it {is_expected.not_to be_absolute_position}
    end

    describe 'with a parent and being positioned itself' do
      subject {Shoes::Dimension.new parent_dimension}

      TESTING_OFFSET = 11

      before :each do
        subject.absolute_start = parent_element_start + TESTING_OFFSET
        subject.extent = 10
      end

      its(:start) {should eq TESTING_OFFSET}
      its(:end) {should eq parent_element_end - subject.element_end}
    end

    describe 'start as center' do
      subject {Shoes::Dimension.new parent_dimension, true}

      it 'takes start as the center' do
        subject.extent = 100
        subject.start = 60
        expect(subject.start).to eq 10
      end
    end
  end

  describe '#extent' do
    let(:parent_element_extent) {600}
    let(:parent_extent) {580}
    let(:parent) {double 'parent', element_extent: parent_element_extent,
                                   extent: parent_extent}

    subject {Shoes::Dimension.new parent}

    it 'gets and sets' do
      subject.extent = extent
      expect(subject.extent).to eq extent
    end

    describe 'negative values' do
      it 'subtracts them from the parent taking margins into account' do
        subject.extent = -70
        expect(subject.extent).to eq parent_element_extent - 70
      end
    end

    describe 'relative values from the parent taking margins into account' do
      it 'takes them relative to the parent for smaller values' do
        subject.extent = 0.8
        expect(subject.extent).to be_within(ONE_PIXEL).of 0.8 *
                                                          parent_element_extent
      end

      it 'handles negative relative values' do
        subject.extent = -0.3
        expect(subject.extent).to be_within(ONE_PIXEL).of 0.7 *
                                                          parent_element_extent
      end

      it 'equal parent extent for 1.0' do
        subject.extent = 1.0
        expect(subject.extent).to eq parent_element_extent
      end

      it 'does not take them relative to the parent for bigger values' do
        subject.extent = 1.3
        expect(subject.extent).to eq 1.3
      end
    end

    describe 'string values' do
      it 'handles pure number strings' do
        subject.extent = '100'
        expect(subject.extent).to eq 100
      end

      it 'handles px strings' do
        subject.extent = '80px'
        expect(subject.extent).to eq 80
      end

      it 'takes care of some px white space' do
        subject.extent = '70 px'
        expect(subject.extent).to eq 70
      end

      it 'also handles negative values' do
        subject.extent = '-50px'
        expect(subject.extent).to eq parent_element_extent - 50
      end

      it 'handles percent as relative value' do
        subject.extent = '75%'
        expect(subject.extent).to be_within(ONE_PIXEL).of 0.75 *
                                                          parent_element_extent
      end

      it 'handles negative percent values' do
        subject.extent = '-10%'
        expect(subject.extent).to be_within(ONE_PIXEL).of 0.9 *
                                                           parent_element_extent
      end

      it 'handles percent values with floats' do
        subject.extent = '20.5%'
        expect(subject.extent).to be_within(ONE_PIXEL).of 0.205 *
                                                           parent_element_extent
      end

      it 'returns nil for invalid strings' do
        subject.extent = 'hell0'
        expect(subject.extent).to be_nil
      end
    end
  end

  describe '#start' do
    let(:start) {23}

    before :each do
      subject.start = start
    end

    its(:start) {should eq start}
    it {is_expected.to be_absolute_position}

    it 'can set a start relative to parent element_extent' do
      subject.start = 0.3
      expected = 0.3 * parent_element_extent
      expect(subject.start).to be_within(ONE_PIXEL).of expected
    end

    # might be surprising if people do calculations that result in a float
    # and all of a sudden they have 10.4 and the button is nowhere to be found
    it 'uses literal float values for values over 1.0' do
      subject.start = 1.01
      expect(subject.start).to eq 1.01
    end

    context '#without a parent' do
      let(:parent_dimension) {nil}

      it 'just takes the relative value' do
        subject.start = 0.8
        expect(subject.start).to eq 0.8
      end
    end
  end

  describe 'with no parent but set dimensions' do
    subject {Shoes::Dimension.new}

    before :each do
      subject.absolute_start = 23
      subject.extent = 45
    end

    its(:end) {should be_nil}
    its(:start) {should be_nil}
  end

  describe '#absolute_start' do
    let(:absolute_start) {8}

    before :each do
      subject.absolute_start = absolute_start
    end

    it 'gets and sets absolute_start' do
      expect(subject.absolute_start).to eq absolute_start
    end

    it {is_expected.to be_positioned}
  end

  describe '#absolute_end' do
    it 'is the sum of start and extent' do
      subject.absolute_start = 7
      subject.extent = 22
      expect(subject.absolute_end).to eq 29 - ONE_PIXEL # pixel counting adjustment
    end

    it 'returns nil if absolute_start is nil but extent is set' do
      subject.absolute_start = nil
      subject.extent = 100
      expect(subject.absolute_end).to be_nil
    end
  end

  describe '#margins' do

    let(:margin_start) {11}
    let(:margin_end) {17}

    before :each do
      subject.margin_start = margin_start
      subject.margin_end = margin_end
    end

    its(:margin_start) {should eq margin_start}
    its(:margin_end) {should eq margin_end}

    context 'absolute_start set' do
      let(:absolute_start) {7}

      before :each do
        subject.absolute_start = absolute_start
      end

      it 'does not influence absolute_start' do
        expect(subject.absolute_start).to eq absolute_start
      end

      it 'does influence element_start' do
        expect(subject.element_start).to eq absolute_start + margin_start
      end

      context 'extent set' do
        let(:extent) {67}

        before :each do
          subject.extent = extent
        end

        it 'does not influence absolute_end' do
          expect(subject.absolute_end).to eq absolute_start + extent - ONE_PIXEL
        end

        it 'does influence element_end' do
          expect(subject.element_end).to eq absolute_start + extent -
                                              margin_end - ONE_PIXEL
        end
      end

      context 'element_extent set' do
        let(:element_extent) {77}

        before :each do
          subject.element_extent = element_extent
        end

        its(:element_extent) {should eq element_extent}
        its(:extent) {should eq element_extent + margin_start + margin_end}
        its(:element_end) {should eq subject.element_start + element_extent -
                                       ONE_PIXEL}
      end

      describe 'relative margins' do
        let(:margin_start) {0.1}
        let(:margin_end) {0.2}

        its(:margin_start) {should be_within(ONE_PIXEL).of 0.1 *
                                                          parent_element_extent}
        its(:margin_end) {should be_within(ONE_PIXEL).of 0.2 *
                                                         parent_element_extent}
      end
    end
  end

  describe '#in_bounds?' do
    let(:absolute_start) {20}
    let(:extent) {100}
    let(:absolute_end) {20 + 100 -ONE_PIXEL} # -1 due to pixel counting adjustment

    before :each do
      subject.absolute_start = absolute_start
      subject.extent = extent
    end

    its(:absolute_end) {should eq absolute_end}

    it {is_expected.to be_in_bounds absolute_start}
    it {is_expected.to be_in_bounds absolute_end}
    it {is_expected.to be_in_bounds absolute_start + ONE_PIXEL}
    it {is_expected.to be_in_bounds absolute_end - ONE_PIXEL}
    it {is_expected.to be_in_bounds 40}
    it {is_expected.to be_in_bounds 105}
    it {is_expected.to be_in_bounds 20.021}
    it {is_expected.not_to be_in_bounds absolute_end + ONE_PIXEL}
    it {is_expected.not_to be_in_bounds absolute_start - ONE_PIXEL
    }
    it {is_expected.not_to be_in_bounds -5}
    it {is_expected.not_to be_in_bounds 0}
    it {is_expected.not_to be_in_bounds 150}
    it {is_expected.not_to be_in_bounds 123178}
  end

  it 'can displace the placement' do
    subject.displace_start = 5
    subject.absolute_start = 10
    expect(subject.element_start).to eq 15
  end

  describe 'start/end/margin and other values parse simple string values' do
    it 'parses a normal number' do
      subject.start = '50'
      expect(subject.start).to eq 50
    end

    it 'parses pixel values' do
      subject.start = '77px'
      expect(subject.start).to eq 77
    end

    it 'parses negative values' do
      subject.start = '-13'
      expect(subject.start).to eq -13
    end

    it 'even parses negative values with px' do
      subject.start = '-22px'
      expect(subject.start).to eq -22
    end

    it 'returns nil for unknown values' do
      subject.start = []
      expect(subject.start).to be_nil
    end
  end

  describe Shoes::ParentDimension do
    let(:parent) {Shoes::Dimension.new}
    let(:parent_start) {7}
    let(:parent_extent) {27}
    let(:margin) {5}

    subject {Shoes::ParentDimension.new parent}

    before :each do
      parent.start        = parent_start
      parent.extent       = parent_extent
      parent.margin_start = margin
      parent.margin_end   = margin
    end

    describe 'it takes some parent values if no values are set' do
      its(:start)  {should eq parent_start}
      its(:extent) {should eq parent_extent}

      its(:margin_start) {should eq 0}
      its(:margin_end)   {should eq 0}

      context 'with parent absolute_start set' do
        before :each do
          parent.absolute_start = 11

          # This would be set by positioning code
          subject.absolute_start = parent.absolute_start + margin
        end

        its(:absolute_start) {should eq parent.absolute_start + margin}
        its(:element_start)  {should eq parent.absolute_start + margin}
        its(:element_end)    {should eq parent.element_end}
      end
    end

    describe 'otherwise it takes its own values' do
      before :each do
        subject.start = start
        subject.extent = extent
        subject.absolute_start = 17
      end

      its(:start) {should eq start}
      its(:extent) {should eq extent}
      its(:absolute_start) {should eq 17}

      it 'can still handle special values like a negative extent' do
        subject.extent = -10
        expect(subject.extent).to eq (parent_extent - 2 * margin) - 10
      end

      it 'can also still handle special values like relative values' do
        subject.extent = 0.8
        expect(subject.extent).to be_within(ONE_PIXEL).of(0.8 * parent.element_extent)
      end
    end

    describe 'it obeys parent bounds' do
      let(:parent_dimension) { double 'parent_dimension',
                                  element_start:  10,
                                  element_end:    20,
                                  absolute_start: 10,
                                  absolute_end:   20,
                                  extent:         10,
                                  element_extent: 10 }

      subject {Shoes::ParentDimension.new parent_dimension}

      it "can't extend beyond parent" do
        subject.absolute_start = 15
        expect(subject.extent).to eq(6)
      end

      it "can't start before parent" do
        subject.absolute_start = 5
        expect(subject.extent).to eq(10)
      end
    end
  end

end

