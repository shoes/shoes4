require 'shoes/swt/spec_helper'

describe Shoes::Swt::Button do
  include_context "swt app"

  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', app: shoes_app, text: text, blk: block, element_width: 100, element_height: 200).as_null_object }
  let(:block) { proc {} }
  let(:real) { double('real', disposed?: false).as_null_object }

  subject { Shoes::Swt::Button.new dsl, parent }

  before :each do
    allow(parent).to receive(:real)
    allow(parent).to receive(:dsl){double(contents: [])}
    allow(dsl).to receive(:width=)
    allow(dsl).to receive(:height=)
    allow(::Swt::Widgets::Button).to receive(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element", 140, 300
  it_behaves_like "removable native element"
  it_behaves_like "updating visibility"

  describe "#initialize" do
    it "sets text on real element" do
      expect(real).to receive(:set_text).with(text)
      subject
    end

    describe 'size' do
      let(:width) {50}
      let(:height) {20}
      let(:size) {double 'real size', x: width, y: height}
      let(:real) {double('button real', size: size, pack: true).as_null_object}

      before :each do
        allow(parent).to receive(:real)
        allow(parent).to receive(:dsl){double(contents: [])}
        allow(::Swt::Widgets::Button).to receive(:new) { real }
      end

      def dsl_for_dimensions(width, height)
        double('dsl', element_width: width, element_height: height, text: text).as_null_object
      end

      def with_dimensions_real_should_be(input_width,    input_height,
                                         expected_width, expected_height)
        dsl = dsl_for_dimensions input_width, input_height
        expect(dsl).to receive(:element_width=).with(expected_width) unless input_width
        expect(dsl).to receive(:element_height=).with(expected_height) unless input_height
        Shoes::Swt::Button.new dsl, parent
      end

      it 'uses only real when width and height are not specified' do
        with_dimensions_real_should_be nil, nil, real.size.x, real.size.y
      end

      it 'uses the real height and specified width if specified' do
        with_dimensions_real_should_be 110, nil, 110, real.size.y
      end

      it 'uses the real width and specified height if specified' do
        with_dimensions_real_should_be nil, 220, real.size.x, 220
      end

      it 'uses both specified values' do
        with_dimensions_real_should_be 130, 220, 130, 220
      end

      it 'sends set_text to the real before packing it #452' do
        expect(real).to receive(:set_text).ordered
        expect(real).to receive(:pack).ordered
        subject
      end
    end
  end

  describe 'eval block' do
    it 'calls the block' do
      expect(block).to receive(:call).with(dsl)
      subject.eval_block block
    end
  end

  describe 'click' do
    it 'adds listener to real object' do
      expect(real).to receive(:addSelectionListener)
      subject.click block
    end

    it 'passes dsl object to block' do
      expect(real).to receive(:addSelectionListener).once do |&blk|
        expect(block).to receive(:call).with(dsl)
        blk.call
      end
      subject.click block
    end
  end
end
