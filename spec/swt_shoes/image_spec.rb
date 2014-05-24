require 'swt_shoes/spec_helper'

describe Shoes::Swt::Image do
  include_context "swt app"

  IMAGE_WIDTH = 3
  IMAGE_HEIGHT = 1

  let(:blk) { double("block") }
  let(:dsl) { Shoes::Image.new shoes_app, parent_dsl, image, opts}
  let(:opts) {{left: left, top: top, width: width, height: height}}
  let(:left) { 100 }
  let(:top) { 200 }
  let(:height) { nil }
  let(:width) {nil}
  let(:image) { "spec/swt_shoes/minimal.png" }

  subject {
    dsl.stub(:file_path) { image }
    Shoes::Swt::Image.new(dsl, parent, blk)
  }

  it_behaves_like "paintable"
  it_behaves_like "clearable"
  it_behaves_like "clickable backend"
  it_behaves_like "togglable"

  describe "paint callback" do
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc", drawImage: true) }

    before :each do
      swt_app.should_receive(:add_paint_listener)
    end

    specify "draws image" do
      dsl.stub element_left: left, element_top: top
      gc.should_receive(:drawImage).with(subject.real, 0, 0, 3, 1, left, top, 3, 1)
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

    it 'can change its width' do
      subject.width = 7
      subject.width.should == 7
    end

    it 'can change its height' do
      subject.height = 7
      subject.height.should == 7
    end

    describe 'with a given width' do
      let(:width) {(IMAGE_WIDTH * 5.8).to_i}
      it 'scales the height' do
        subject.height.should == (IMAGE_HEIGHT * 5.8).to_i
      end
    end

    describe 'with a given height' do
      let(:height) {IMAGE_HEIGHT * 4}

      it 'scales the width' do
        subject.width.should == IMAGE_WIDTH * 4
      end
    end

    describe 'with a given width and height' do
      let(:width) {1}
      let(:height) {2}
      it 'sets the given width' do
        subject.width.should == 1
      end

      it 'sets the given height' do
        subject.height.should == 2
      end
    end
  end
end
