require 'swt_shoes/spec_helper'

describe Shoes::Swt::Rect do
  let(:container) { double('container', :disposed? => false) }
  let(:app) { double('app', :real => container, :add_paint_listener => true, :dsl => dsl).as_null_object }
  let(:dsl) { double("dsl object", hidden: false, rotate: 0).as_null_object }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }
  let(:real_dsl) {::Shoes::Rect.new app, left, top, width, height}

  subject {
    Shoes::Swt::Rect.new real_dsl, app
  }

  context "#initialize" do
    it "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like 'clickable backend'
end
