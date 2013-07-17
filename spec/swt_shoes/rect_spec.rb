require 'swt_shoes/spec_helper'

describe Shoes::Swt::Rect do
  let(:container) { double('container', :disposed? => false) }
  let(:app) { double('app', :real => container, :add_paint_listener => true, :dsl => dsl) }
  let(:dsl) { double("dsl object", hidden: false, rotate: 0).as_null_object }
  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 111 }

  subject {
    Shoes::Swt::Rect.new dsl, app, left, top, width, height
  }

  context "#initialize" do
    it { should be_an_instance_of(Shoes::Swt::Rect) }
    its(:dsl) { should be(dsl) }

    it "adds paint listener" do
      app.should_receive(:add_paint_listener)
      subject
    end
  end

  it_behaves_like "paintable"
  it_behaves_like "movable shape", 10, 20
  it_behaves_like 'clickable backend'
end
