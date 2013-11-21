require 'swt_shoes/spec_helper'

describe Shoes::Swt::Check do
  let(:text) { "TEXT" }
  let(:container) { double('container', is_disposed?: false).as_null_object }
  let(:gui) { double('gui', real: container) }
  let(:app) { double('app', gui: gui).as_null_object }
  let(:dsl) { double('dsl',
                     :app => app, :real => real, :visible? => true,
                     :left => 42, :top => 66,
                     :width => 100, :width= => true,
                     :height => 200, :height= => true,
                     blk: block, contents: []) }
  let(:parent) { double('parent', real: true, dsl: double(contents: []) ) }
  let(:block) { proc {} }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Check.new dsl, parent }

  before :each do
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element"
  it_behaves_like "selectable"
  it_behaves_like "togglable"
end
