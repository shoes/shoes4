require 'swt_shoes/spec_helper'

describe Shoes::Swt::Rect do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:dsl) {::Shoes::Rect.new shoes_app, parent, left, top, width, height}
  let(:block) {double "WHY OH GOD WHY"}

  subject {
    Shoes::Swt::Rect.new dsl, swt_app, block
  }

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like 'clickable backend'
end
