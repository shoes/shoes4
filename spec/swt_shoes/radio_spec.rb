require 'swt_shoes/spec_helper'

describe Shoes::Swt::Radio do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :width= => true, :height= => true) }
  let(:parent) { double('parent', real: true, dsl: mock(contents: []) ) }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Radio.new dsl, parent, block }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "movable element"

  it "calls get_selection when checked? is called" do
    real.should_receive :get_selection
    subject.checked?
  end

  it "calls set_selection when checked= is called" do
    real.should_receive(:set_selection).with(true)
    subject.checked = true
  end

  it "calls set_focus when focus is called" do
    real.should_receive :set_focus
    subject.focus
  end
end
