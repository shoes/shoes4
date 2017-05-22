# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Background do
  include_context "dsl app"

  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:blue) { Shoes::COLORS[:blue] }
  let(:input_opts) { {left: left, top: top, width: width, height: height, color: blue} }
  subject(:background) { Shoes::Background.new(app, parent, blue, input_opts) }

  before do
    parent.height = height + 2
    parent.width  = width + 2
  end

  it "retains app" do
    expect(background.app).to eq(app)
  end

  it "creates gui object" do
    expect(background.gui).not_to be_nil
  end

  it_behaves_like "object with fill", :blue

  it_behaves_like "object with style" do
    subject(:background) { Shoes::Background.new(app, parent, Shoes::COLORS[:black]) }
    let(:subject_without_style) { Shoes::Background.new(app, parent, blue) }
    let(:subject_with_style) { Shoes::Background.new(app, parent, blue, arg_styles) }
  end

  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    subject { Shoes::Background.new(app, parent, blue, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Background.new(app, parent, blue, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end

  it { is_expected.not_to be_takes_up_space }

  describe "dsl" do
    it "sets color with a valid hex string" do
      background = dsl.background("#fff")
      expect(background.fill).to eq(Shoes::COLORS[:white])
    end

    it "raises an argument error with an invalid hex string" do
      expect { dsl.background('#ffq') }.to raise_error('Bad hex color: #ffq')
    end

    it 'ignores the background with no valid image but logs' do
      expect(Shoes.logger).to receive(:error)
      expect { dsl.background('fake-shoes.jpg') }.not_to raise_error
    end

    it 'creates a Shoes::Background with a valid image' do
      expect(dsl.background('shoes-icon.png')).to be_an_instance_of(Shoes::Background)
    end
  end
end
