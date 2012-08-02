require 'swt_shoes/spec_helper'
require 'shoes/color'

describe Shoes::Swt::Border do
  let(:dsl) { double('dsl') }
  let(:parent) { double('parent', real: real, dsl: true) }
  let(:block) { double('block') }
  let(:real) { double('real') }

  subject { Shoes::Swt::Border.new dsl, parent, block }

  before :each do
    dsl.stub(:color).and_return(Shoes::COLORS[:red])
  end

  it { real.should_receive(:addPaintListener); subject }

  let(:paint_event) do
    paint_event = double "paint_event"
    paint_event.stub(height: APP_HEIGHT, width: APP_WIDTH)
    paint_event
  end
end
