require 'swt_shoes/spec_helper'

describe Shoes::Swt::Check do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :width= => true, :height= => true, contents: []) }
  let(:parent) { double('parent', real: true, dsl: mock(contents: []) ) }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Check.new dsl, parent, block }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "clickable"
  it_behaves_like "movable element"
  it_behaves_like "selectable"

  it "calls set_focus when focus is called" do
    real.should_receive :set_focus
    subject.focus
  end
end
