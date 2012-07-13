require 'swt_shoes/spec_helper'
require 'shoes/color'

describe Shoes::Swt::Background do
  let(:dsl) { double('dsl') }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::Background.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    dsl.stub(:color).and_return(Shoes::COLORS[:red])
  end

  it { respond_to :background= }

  let(:paint_event) do
    paint_event = double "paint_event"
    paint_event.stub(height: APP_HEIGHT, width: APP_WIDTH)
    paint_event
  end
end
