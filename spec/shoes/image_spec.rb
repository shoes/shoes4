require 'shoes/spec_helper'

describe Shoes::Image do
  describe "basic" do
    let(:app) { Shoes::App.new }
    let(:parent) { double("parent").as_null_object }
    let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
    let(:updated_filename) { File.expand_path "../../../static/shoes-icon-brown.png", __FILE__ }
    subject { Shoes::Image.new(app, parent, filename) }
    it { should be_instance_of(Shoes::Image) }
    it "should update image path" do
      subject.path = updated_filename
      subject.path.should eql updated_filename
    end
    it_behaves_like "movable object"
    it_behaves_like "clearable object"
  end

  describe 'accepts web URL' do
    let(:app) { Shoes::App.new }
    let(:parent) { double("parent").as_null_object }
    let(:filename) { "http://is.gd/GVAGF7" }
    let(:opts) { {app: app} }
    subject { Shoes::Image.new(app, parent, filename, opts) }
    it { subject.file_path.should eql "http://is.gd/GVAGF7" }
  end
end
