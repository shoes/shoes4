# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Image do
  include_context "dsl app"

  let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
  let(:updated_filename) { File.expand_path "../../../static/shoes-icon-brown.png", __FILE__ }

  describe "basic" do
    let(:left) { 10 }
    let(:top) { 20 }
    let(:width) { 100 }
    let(:height) { 200 }

    subject(:image) { Shoes::Image.new(app, parent, filename, left: left, top: top, width: width, height: height) }

    it { is_expected.to be_instance_of(Shoes::Image) }

    it "should update image path" do
      subject.path = updated_filename
      expect(subject.path).to eq(updated_filename)
    end

    it_behaves_like "movable object"
    it_behaves_like "object with dimensions"
    it_behaves_like "object with hover"
    it_behaves_like "clickable object"

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

    let(:app_dir) { "shoes-core/spec/shoes" }
    before { Shoes.configuration.app_dir = app_dir }

    describe 'invalid path' do
      let(:filename) { 'does_not_exist' }
      it 'raises an error' do
        expect { subject }.to raise_error Shoes::FileNotFoundError
      end
    end

    describe 'absolute path' do
      let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
      its(:file_path) { should eq filename }
    end

    describe 'relative to app directory' do
      let(:filename) { 'images/shoe.jpg' }
      its(:file_path) { should eq "#{app_dir}/#{filename}" }
    end

    describe 'relative to Dir.pwd' do
      let(:filename) { 'shoes-core/static/shoes-icon.png' }
      its(:file_path) { should eq "#{Dir.pwd}/#{filename}" }
    end

    describe 'relative to shoes-core/static' do
      let(:filename) { 'shoes-icon.png' }
      its(:file_path) { should eq File.expand_path("shoes-core/static/#{filename}") }
    end

    describe 'accepts web URL' do
      let(:filename) { "http://is.gd/GVAGF7" }
      its(:file_path) { should eq("http://is.gd/GVAGF7") }
    end
  end

  describe "dsl" do
    let(:opts)  { {} }
    let(:image) { dsl.image filename, opts }

    it 'raises if called with block' do
      expect { dsl.image filename, opts, &->() {} }.to raise_error(Shoes::NotImplementedError)
    end

    it 'should set the path' do
      expect(image.file_path).to eq(filename)
    end

    context 'with :top and :left style attributes' do
      let(:opts) { {left: 55, top: 66} }

      it 'should set the left' do
        expect(image.left).to eq(55)
      end

      it 'should set the top' do
        expect(image.top).to eq(66)
      end
    end
  end
end
