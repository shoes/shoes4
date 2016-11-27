require 'spec_helper'

describe Shoes::Swt::Oval do
  include_context "swt app"

  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:dsl) { ::Shoes::Oval.new shoes_app, parent, left, top, width, height }

  subject do
    Shoes::Swt::Oval.new(dsl, swt_app)
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like 'clickable backend'
end
