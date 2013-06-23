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
  let(:parent) { double("parent", real: real, dsl: parent_dsl, app: app) }
  let(:dsl) { double("dsl object", left: left, top: top, app: app, hidden: false, opts: {})}
  let(:left) { 100 }
  let(:top) { 200 }
  let(:mock_image) { mock(:swt_image, getImageData: MockSize.new, addListener: true, add_paint_listener: true) }
  let(:real) { mock_image }
  let(:gui) { double("gui", real: real, mscs: []) }
  let(:app) { double("app", gui: gui) }
  let(:width) { 128 }
  let(:height) { 128 }

  subject {
    ::Swt::Graphics::Image.stub(:new) { mock_image}
    dsl.stub(:file_path)
    Shoes::Swt::Image.new(dsl, parent, blk)
  }

  it_behaves_like "paintable"
  it_behaves_like "clearable"

  describe "paint callback" do
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc", drawImage: true) }

    before :each do
      container.should_receive(:add_paint_listener)
    end

    specify "draws image" do
      gc.should_receive(:drawImage).with(real, 0, 0, width, height, left, top, width, height)
      subject.painter.call(event)
    end
  end
end
