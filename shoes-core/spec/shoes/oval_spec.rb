require 'spec_helper'

describe Shoes::Oval do
  include_context "dsl app"

  let(:left) { 20 }
  let(:top) { 30 }
  let(:width) { 100 }
  let(:height) { 200 }

  describe "basic" do
    subject { Shoes::Oval.new(app, parent, left, top, width, height) }

    it_behaves_like "an art element" do
      let(:subject_without_style) { Shoes::Oval.new(app, parent, left, top, width, height) }
      let(:subject_with_style) { Shoes::Oval.new(app, parent, left, top, width, height, arg_styles) }
    end
    it_behaves_like "left, top as center"
  end
end
