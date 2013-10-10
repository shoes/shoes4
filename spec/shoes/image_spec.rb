require 'shoes/spec_helper'

describe Shoes::Image do
  describe "basic" do
    let(:left) { 10 }
    let(:top) { 20 }
    let(:width) { 100 }
    let(:height) { 200 }

    let(:app) { Shoes::App.new }
    let(:parent) { Shoes::Flow.new(app, app) }
    let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
    let(:updated_filename) { File.expand_path "../../../static/shoes-icon-brown.png", __FILE__ }

    subject { Shoes::Image.new(app, parent, filename, left: left, top: top, width: width, height: height) }
    it { should be_instance_of(Shoes::Image) }

    it "should update image path" do
      subject.path = updated_filename
      subject.path.should eql updated_filename
    end

    it_behaves_like "movable object"
    it_behaves_like "clearable object"
    it_behaves_like "object with dimensions"

    describe "relative dimensions from parent" do
      let(:relative_opts) { { left: left, top: top, width: relative_width, height: relative_height } }
      subject { Shoes::Image.new(app, parent, filename, relative_opts) }

      it_behaves_like "object with relative dimensions"
    end
  end

  describe 'accepts web URL' do
    let(:app) { Shoes::App.new }
    let(:parent) { Shoes::Flow.new(app, app) }
    let(:filename) { "http://is.gd/GVAGF7" }
    let(:opts) { {app: app} }

    subject { Shoes::Image.new(app, parent, filename, opts) }

    it { subject.file_path.should eql "http://is.gd/GVAGF7" }
  end
end
