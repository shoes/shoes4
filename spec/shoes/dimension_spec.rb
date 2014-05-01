require 'spec_helper'

describe Shoes::Dimension do

  subject {Shoes::Dimension.new nil}
  let(:start) {10}
  let(:extent) {21}
  let(:parent_element_start) {34}
  let(:parent_element_end) {83}
  let(:parent_dimension) {double 'parent_dimension',
                                 element_start: parent_element_start,
                                 element_end: parent_element_end }


  describe 'initialization' do
    describe 'without arguments (even no parent)' do
      subject {Shoes::Dimension.new nil}

      its(:start) {should eq nil}
      its(:end) {should eq nil}
      its(:extent) {should eq nil}
      its(:margin_start) {should eq 0}
      its(:margin_end) {should eq 0}
      its(:displace_start) {should eq 0}
      it {should_not be_positioned}
      it {should_not be_absolute_position}
      it {should_not be_start_as_center}
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
      it {should be_start_as_center}

      it 'takes start as the center' do
        subject.extent = 100
        subject.start = 60
        expect(subject.start).to eq 10
      end
    end
  end

  describe 'extent' do
    let(:parent_extent) {200}
    let(:parent) {double 'parent', extent: parent_extent}

    subject {Shoes::Dimension.new parent}

    it 'gets and sets' do
      subject.extent = extent
      expect(subject.extent).to eq extent
    end

    describe 'negative values' do
      it 'subtracts them from the parent' do
        subject.extent = -70
        expect(subject.extent).to eq parent_extent - 70
      end
    end

    describe 'relative values' do
      it 'takes them relative to the parent for smaller values' do
        subject.extent = 0.8
        expect(subject.extent).to be_within(1).of 0.8 * parent_extent
      end

      it 'takes them relative to the parent for bigger values' do
        subject.extent = 1.3
        expect(subject.extent).to be_within(1).of 1.3 * parent_extent
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
        expect(subject.extent).to eq parent_extent - 50
      end

      it 'handles percent as relative value' do
        subject.extent = '75%'
        expect(subject.extent).to be_within(1).of 0.75 * parent_extent
      end

      it 'returns nil for invalid strings' do
        subject.extent = 'hell0'
        expect(subject.extent).to be_nil
      end
    end
  end

  describe 'start' do
    let(:start) {23}

    before :each do
      subject.start = start
    end

    its(:start) {should eq start}
    it {should be_absolute_position}
  end

  describe 'absolute_start' do
    let(:absolute_start) {8}

    before :each do
      subject.absolute_start = absolute_start
    end

    it 'gets and sets absolute_start' do
      expect(subject.absolute_start).to eq absolute_start
    end

    it {should be_positioned}
  end

  describe 'absolute_end' do
    it 'is the sum of start and extent' do
      subject.absolute_start = 7
      subject.extent = extent
      expect(subject.extent).to eq extent
    end
  end

  describe 'margins' do
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
          expect(subject.absolute_end).to eq absolute_start + extent - 1
        end

        it 'does influence element_end' do
          expect(subject.element_end).to eq absolute_start + extent -
                                              margin_end - 1
        end
      end
    end
  end

  describe 'in_bounds?' do
    let(:absolute_start) {20}
    let(:extent) {100}
    let(:absolute_end) {20 + 100 -1} # -1 due to pixel counting adjustment

    before :each do
      subject.absolute_start = absolute_start
      subject.extent = extent
    end

    its(:absolute_end) {should eq absolute_end}

    it {should be_in_bounds absolute_start}
    it {should be_in_bounds absolute_end}
    it {should be_in_bounds absolute_start + 1}
    it {should be_in_bounds absolute_end - 1}
    it {should be_in_bounds 40}
    it {should be_in_bounds 105}
    it {should be_in_bounds 20.021}
    it {should_not be_in_bounds absolute_end + 1}
    it {should_not be_in_bounds absolute_start - 1}
    it {should_not be_in_bounds -5}
    it {should_not be_in_bounds 0}
    it {should_not be_in_bounds 150}
    it {should_not be_in_bounds 123178}
  end

  it 'can displace the placement' do
    subject.displace_start = 5
    subject.absolute_start = 10
    expect(subject.element_start).to eq 15
  end

end