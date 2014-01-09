require 'shoes/spec_helper'

describe Shoes::Image do
  include_context "dsl app"

  describe "basic" do
    let(:left) { 10 }
    let(:top) { 20 }
    let(:width) { 100 }
    let(:height) { 200 }

    let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
    let(:updated_filename) { File.expand_path "../../../static/shoes-icon-brown.png", __FILE__ }

    subject(:image) { Shoes::Image.new(app, parent, filename, left: left, top: top, width: width, height: height) }

    it { should be_instance_of(Shoes::Image) }

    it "should update image path" do
      subject.path = updated_filename
      expect(subject.path).to eq(updated_filename)
    end

    it_behaves_like "movable object"
    it_behaves_like "clearable object"
    it_behaves_like "object with dimensions"

    describe "relative dimensions from parent" do
      subject { Shoes::Image.new(app, parent, filename, relative_opts) }
      it_behaves_like "object with relative dimensions"
    end

    describe "negative dimensions" do
      subject { Shoes::Image.new(app, parent, filename, negative_opts) }
      it_behaves_like "object with negative dimensions"
    end
  end

  describe 'accepts web URL' do
    let(:filename) { "http://is.gd/GVAGF7" }
    subject { Shoes::Image.new(app, parent, filename, input_opts) }

    its(:file_path) { should eq("http://is.gd/GVAGF7") }
  end
end
