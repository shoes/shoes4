require 'spec_helper'

describe Shoes::Arrow do
  include_context "dsl app"

  let(:parent) { app }
  let(:left) { 44 }
  let(:top) { 66 }
  let(:width) { 111 }
  let(:height) { 111 }
  subject(:arrow) { Shoes::Arrow.new(app, parent, left, top, width) }

  describe '#style' do
    it 'restyles handed in fill colors (even the weird ones)' do
      subject.style fill: 'fff'
      expect(subject.style[:fill]).to eq Shoes::Color.new 255, 255, 255
    end
  end

  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Arrow.new(app, parent, left, top, width) }
    let(:subject_with_style) { Shoes::Arrow.new(app, parent, left, top, width, arg_styles) }
  end
  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
  it_behaves_like 'object with parent'
  it_behaves_like "object with hover"
  it_behaves_like "an art element"
end
