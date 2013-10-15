require 'swt_shoes/spec_helper'

describe Shoes::Swt::Button do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', text: text, blk: block, width: 100, height: 200).as_null_object }
  let(:parent) { double('parent') }
  let(:block) { proc {} }
  let(:real) { double('real', disposed?: false).as_null_object }

  subject { Shoes::Swt::Button.new dsl, parent }

  before :each do
    parent.stub(:real)
    parent.stub(:dsl){double(contents: [])}
    dsl.stub(:width=)
    dsl.stub(:height=)
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element", 140, 300
  it_behaves_like "clearable native element"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:set_text).with(text)
      subject
    end

    describe 'size' do
      let(:width) {50}
      let(:height) {20}
      let(:size) {double 'real size', x: width, y: height}
      let(:real) {double('button real', size: size, pack: true).as_null_object}

      before :each do
        parent.stub(:real)
        parent.stub(:dsl){double(contents: [])}
        ::Swt::Widgets::Button.stub(:new) { real }
      end

      def dsl_for_dimensions(width, height)
        double('dsl', width: width, height: height, text: text).as_null_object
      end

      def with_dimensions_real_should_be(input_width,    input_height,
                                         expected_width, expected_height)
        dsl = dsl_for_dimensions input_width, input_height
        dsl.should_receive(:width=).with(expected_width) unless input_width
        dsl.should_receive(:height=).with(expected_height) unless input_height
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
    end
  end

  describe 'eval block' do
    it 'calls the block' do
      block.should_receive(:call).with(dsl)
      subject.eval_block
    end
  end
end
