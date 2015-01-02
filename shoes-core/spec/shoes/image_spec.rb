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

    it { is_expected.to be_instance_of(Shoes::Image) }

    it "should update image path" do
      subject.path = updated_filename
      expect(subject.path).to eq(updated_filename)
    end

    it_behaves_like "movable object"
    it_behaves_like "object with dimensions"

    it_behaves_like "object with style" do
      let(:subject_without_style) { Shoes::Image.new(app, parent, filename) }
      let(:subject_with_style) { Shoes::Image.new(app, parent, filename, arg_styles) }
    end

    describe "relative dimensions from parent" do
      subject { Shoes::Image.new(app, parent, filename, relative_opts) }
      it_behaves_like "object with relative dimensions"
    end

    describe "negative dimensions" do
      subject { Shoes::Image.new(app, parent, filename, negative_opts) }
      it_behaves_like "object with negative dimensions"
    end
  end

  describe 'file source' do
    subject { Shoes::Image.new(app, parent, filename, input_opts) }

    context 'invalid path' do
      let(:filename) { 'something_crazy' }
      it 'should raise an error' do
        expect { subject }.to raise_error Shoes::FileNotFoundError
      end
    end

    context 'absolute path' do
      let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
      its(:file_path) { should eq filename }
    end

    context 'relative path' do
      let(:filename) { 'shoes-core/static/shoes-icon.png' }
      its(:file_path) { should eq "#{Dir.pwd}/#{filename}" }
    end

    describe 'accepts web URL' do
      let(:filename) { "http://is.gd/GVAGF7" }
      its(:file_path) { should eq("http://is.gd/GVAGF7") }
    end
  end
end
