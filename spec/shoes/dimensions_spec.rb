require 'shoes/spec_helper'

describe Shoes::Dimensions do

  let(:left) {10}
  let(:top) {20}
  let(:width) {100}
  let(:height) {150}
  subject {Shoes::Dimensions.new left, top, width, height}

  describe 'initialization' do
    describe 'without arguments' do
      subject {Shoes::Dimensions.new}

      its(:left) {should eq 0}
      its(:top) {should eq 0}
      its(:width) {should eq 0}
      its(:height) {should eq 0}
    end

    describe 'with 2 arguments' do
      subject {Shoes::Dimensions.new left, top}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq 0}
      its(:height) {should eq 0}
    end

    describe 'with 4 arguments' do
      subject {Shoes::Dimensions.new left, top, width, height}

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}
    end

    describe 'with a hash' do
      subject { Shoes::Dimensions.new left:   left,
                                      top:    top,
                                      width:  width,
                                      height: height }

      its(:left) {should eq left}
      its(:top) {should eq top}
      its(:width) {should eq width}
      its(:height) {should eq height}

      context 'missing width' do
        subject { Shoes::Dimensions.new left:   left,
                                        top:    top,
                                        height: height }

        its(:width) {should eq 0}
      end
    end

    describe 'additional dimension methods' do
      its(:right) {should eq left + width}
      its(:bottom) {should eq top + height}
    end

    describe 'in_bounds?' do
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