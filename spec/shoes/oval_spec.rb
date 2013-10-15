require 'shoes/spec_helper'

describe Shoes::Oval do
  let(:left) { 20 }
  let(:top) { 30 }
  let(:width) { 100 }
  let(:height) { 200 }
  let(:app) { Shoes::App.new }
  let(:parent) { app }

  describe "basic" do
    subject { Shoes::Oval.new(app, left, top, width, height) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "object with dimensions"
    it_behaves_like "movable object"
    it_behaves_like "left, top as center"
  end
end
