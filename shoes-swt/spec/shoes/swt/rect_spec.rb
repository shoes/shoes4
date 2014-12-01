require 'shoes/swt/spec_helper'

describe Shoes::Swt::Rect do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:dsl) {::Shoes::Rect.new shoes_app, parent, left, top, width, height}

  subject {
    Shoes::Swt::Rect.new dsl, swt_app
  }

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like 'clickable backend'
end
