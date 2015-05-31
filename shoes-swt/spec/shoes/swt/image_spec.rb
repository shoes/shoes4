require 'shoes/swt/spec_helper'

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
  let(:image_path) { File.dirname(__FILE__) + '/minimal.png' }
  let(:image) { image_path }

  subject {
    allow(dsl).to receive(:file_path) { image }
    dsl.gui #creating a new instance leads to two initialize calls
  }

  it_behaves_like "paintable"
  it_behaves_like "removable"
  it_behaves_like "clickable backend"
  it_behaves_like "updating visibility"

  shared_examples_for 'image dimensions' do |image_width, image_height|
    describe 'dimensions' do
      it 'has the given width' do
        expect(subject.width).to eq(image_width)
      end

      it 'has the given height' do
        expect(subject.height).to eq(image_height)
      end

      it 'can change its width' do
        subject.width = 7
        expect(subject.width).to eq(7)
      end

      it 'can change its height' do
        subject.height = 7
        expect(subject.height).to eq(7)
      end

      describe 'with a given width' do
        let(:width) {(image_width * 5.8).to_i}
        it 'scales the height' do
          expect(subject.height).to eq((image_height * 5.8).to_i)
        end
      end

      describe 'with a given height' do
        let(:height) {image_height * 4}

        it 'scales the width' do
          expect(subject.width).to eq(image_width * 4)
        end
      end

      describe 'with a given width and height' do
        let(:width) {1}
        let(:height) {2}
        it 'sets the given width' do
          expect(subject.width).to eq(1)
        end

        it 'sets the given height' do
          expect(subject.height).to eq(2)
        end
      end
    end
  end

  # note the image used is 3x1 pixel big
  it_behaves_like 'image dimensions', IMAGE_WIDTH, IMAGE_HEIGHT

  describe "paint callback" do
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc", drawImage: true) }

    before :each do
      expect(swt_app).to receive(:add_paint_listener)
    end

    specify "draws image" do
      allow(dsl).to receive_messages element_left: left, element_top: top
      expect(gc).to receive(:drawImage).with(subject.real, 0, 0, 3, 1, left, top, 3, 1)
      subject.painter.call(event)
    end
  end

  describe "painting raw images" do
    let(:image) { File.read(image_path, mode: "rb") }

    specify "loads image from raw data" do
      subject.real.image_data.width = 3
      subject.real.image_data.height = 1
    end
  end

  describe 'downloading an image' do
    let(:image_url) {'http://example.com/shoes.jpg'}
    let(:image) {image_url}

    it 'sends a download call to the download method' do
      expect(shoes_app).to receive(:download).with(image_url, anything)
      subject
    end

  end

  describe 'gif' do
    let(:image_path) { File.dirname(__FILE__) + '/minimal.gif' }

    it 'loads and displays the iamge without raising an error' do
      expect {subject}.not_to raise_error
    end

    GIF_WIDTH  = 400
    GIF_HEIGHT = 267

    it_behaves_like 'image dimensions', GIF_WIDTH, GIF_HEIGHT
  end
end
