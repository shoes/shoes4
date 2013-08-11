require 'swt_shoes/spec_helper'

describe Shoes::Swt::Image do

  IMAGE_WIDTH = 3
  IMAGE_HEIGHT = 1

  let(:gui_container_real) { container }
  let(:container) { parent.real }
  let(:blk) { double("block") }
  let(:parent_dsl) { double("parent dsl", contents: []) }
  let(:parent) { double("parent", real: real, dsl: parent_dsl, app: app) }
  let(:dsl) { double("dsl object", left: left, top: top, app: app, hidden: false, opts: {})}
  let(:left) { 100 }
  let(:top) { 200 }
  let(:real) { double 'real', addListener: true, add_paint_listener: true }
  let(:gui) { double("gui", real: real, clickable_elements: [], add_clickable_element: nil) }
  let(:app) { double("app", gui: gui) }
  let(:image) { "spec/swt_shoes/minimal.png" }

  subject {
    dsl.stub(:file_path) { image }
    Shoes::Swt::Image.new(dsl, parent, blk)
  }

  it_behaves_like "paintable"
  it_behaves_like "clearable"
  it_behaves_like 'clickable backend'

  describe "paint callback" do
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc", drawImage: true) }

    before :each do
      container.should_receive(:add_paint_listener)
    end

    specify "draws image" do
      gc.should_receive(:drawImage).with(subject.real, 0, 0, 3, 1, 100, 200, 3, 1)
      subject.painter.call(event)
    end
  end

  describe "painting raw images" do
    let(:image) { File.read("spec/swt_shoes/minimal.png", :mode => "rb") }

    specify "loads image from raw data" do
      subject.real.image_data.width = 3
      subject.real.image_data.height = 1
    end
  end

  # note the image used is 3x1 pixel big
  describe 'dimensions' do

    it 'has the given width' do
      subject.width.should == IMAGE_WIDTH
    end

    it 'has the given height' do
      subject.height.should == IMAGE_HEIGHT
    end

  end
end
