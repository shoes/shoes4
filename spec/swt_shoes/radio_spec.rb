require 'swt_shoes/spec_helper'

describe Shoes::Swt::Radio do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', :width => 100, :width= => true, :height => 200, :height= => true, blk: block) }
  let(:parent) { double('parent', real: true, dsl: double(contents: []) ) }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Radio.new dsl, parent }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"

end
