require 'swt_shoes/spec_helper'

describe Shoes::Swt::Image do
  class MockSize
    def width; 128 end
    def height; 128 end
  end

  let(:gui_container_real) { container }
  let(:container) { parent.real }
  let(:blk) { double("block") }
  let(:parent_dsl) { double("parent dsl", contents: []) }
  let(:parent) { double("parent", real: true, dsl: parent_dsl) }
  let(:dsl) { double("dsl object", left: left, top: top)}
  let(:left) { 100 }
  let(:top) { 200 }
  let(:mock_image) { mock(:swt_image, getImageData: MockSize.new) }
  let(:real) { mock_image }

  subject {
    ::Swt::Graphics::Image.stub(:new) { mock_image}
    dsl.stub(:file_path)
    dsl.stub(:width=)
    dsl.stub(:height=)
    Shoes::Swt::Image.new(dsl, parent, blk)
  }

  it_behaves_like "paintable"

  describe "paint callback" do
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc", drawImage: true) }

    before :each do
      container.should_receive(:add_paint_listener)
    end

    specify "draws image" do
      gc.should_receive(:drawImage).with(real, left, top)
      subject.paint_callback.call(event)
    end
  end
end
