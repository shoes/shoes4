require 'shoes/swt/spec_helper'

describe Shoes::Swt::Check do
  include_context "swt app"

  let(:text) { "TEXT" }
  let(:dsl) { double('dsl',
                     :app    => shoes_app, :visible? => true,
                     :left   => 42, :top => 66,
                     :element_left => 42, element_top: 66,
                     :width  => 100, :width= => true,
                     :element_width => 100, element_height: 200,
                     :height => 200, :height= => true,
                     blk:    block, contents: []) }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Check.new dsl, parent }

  before :each do
    allow(::Swt::Widgets::Button).to receive(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"
  it_behaves_like "updating visibility"
end
