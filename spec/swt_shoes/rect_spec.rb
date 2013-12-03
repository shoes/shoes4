require 'swt_shoes/spec_helper'

describe Shoes::Swt::Rect do
  include_context "swt app"

#  let(:container) { double('container', :disposed? => false) }
#  let(:gui) { double('gui', :real => container).as_null_object}
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:dsl) {::Shoes::Rect.new shoes_app, left, top, width, height}

  subject {
    Shoes::Swt::Rect.new dsl, swt_app
  }

  it_behaves_like "paintable"
  it_behaves_like "togglable"
  it_behaves_like 'clickable backend'
end
