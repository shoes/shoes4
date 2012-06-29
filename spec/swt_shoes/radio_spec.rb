require 'swt_shoes/spec_helper'

describe Shoes::Swt::Radio do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl') }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Radio.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "movable object with disposable real element"
end
