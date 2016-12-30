require 'spec_helper'

describe Shoes::Rect do
  include_context "dsl app"

  let(:parent) { app }
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 333 }
  subject(:rect) { Shoes::Rect.new(app, parent, left, top, width, height) }

  describe '#style' do
    it 'restyles handed in fill colors (even the weird ones)' do
      subject.style fill: 'fff'
      expect(subject.style[:fill]).to eq Shoes::Color.new 255, 255, 255
    end
  end

  it "retains app" do
    expect(rect.app).to eq(app)
  end

  it "creates gui object" do
    expect(rect.gui).not_to be_nil
  end

  it_behaves_like "an art element" do
    let(:subject_without_style) { Shoes::Rect.new(app, parent, left, top, width, height) }
    let(:subject_with_style) { Shoes::Rect.new(app, parent, left, top, width, height, arg_styles) }
  end
  it_behaves_like "left, top as center"
end
