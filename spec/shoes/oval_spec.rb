require 'shoes/spec_helper'

describe Shoes::Oval do
  let(:gui) { double('gui') }
  let(:app) { double('app', gui: gui) }
  let(:opts) { {app: app} }

  before :each do
    Shoes::Mock::Oval.any_instance.stub(:real) { mock( size:
      mock(x: 100, y: 100) ) }
  end

  describe "basic" do
    subject { Shoes::Oval.new(20, 30, 100, 200, opts) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "movable object"
  end

  context "(eccentric)" do
    subject { Shoes::Oval.new(20, 30, 100, 200, opts) }

    it { should be_instance_of(Shoes::Oval) }
    its (:top) { should eq(30) }
    its (:left) { should eq(20) }
    its (:width) { should eq(100) }
    its (:height) { should eq(200) }
  end

  shared_examples_for "circle" do
    it { should be_instance_of(Shoes::Oval) }
    its (:top) { should eq(30) }
    its (:left) { should eq(20) }
    its (:width) { should eq(100) }
    its (:height) { should eq(100) }
  end

  context "(circle) created with explicit arguments:" do
    context "width and height" do
      subject { Shoes::Oval.new(20, 30, 100, 100, opts) }
      it_behaves_like "circle"
    end

    context "radius" do
      subject { Shoes::Oval.new(20, 30, 50, opts) }
      it_behaves_like "circle"
    end
  end

  context "(circle) created with style hash:" do
    context "left, top, height, width" do
      options = {left: 20, top: 30, width: 100, height: 100}
      subject { Shoes::Oval.new(opts.merge(options)) }
      it_behaves_like "circle"
    end

    context "left, top, height, width, center: false" do
      options = {left: 20, top: 30, width: 100, height: 100, center: false}
      subject { Shoes::Oval.new(opts.merge options ) }
      it_behaves_like "circle"
    end

    context "left, top, radius" do
      options = {left: 20, top: 30, radius: 50}
      subject { Shoes::Oval.new(opts.merge options) }
      it_behaves_like "circle"
    end

    context "left, top, width, height, center: true" do
      options = {left: 70, top: 80, width: 100, height: 100, center: true}
      subject { Shoes::Oval.new(opts.merge options) }
      it_behaves_like "circle"
    end
  end
end
