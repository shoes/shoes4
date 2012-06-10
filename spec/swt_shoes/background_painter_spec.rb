require 'swt_shoes/spec_helper'
APP_WIDTH = 400
APP_HEIGHT = 200

# Helper method
def create_painter_with_options(options)
  # the "color" and nil parameters should not be accessed
  Shoes::Swt::BackgroundPainter.new "color", options, nil
end

describe Shoes::Swt::BackgroundPainter do

  describe "calculating coordines" do
    let(:paintEvent) do
      paintEvent = double "paintEvent"
      paintEvent.stub(height: APP_HEIGHT, width: APP_WIDTH)
      paintEvent
    end
    describe "set_width" do

      it "sets the width to options[:width] if supplied" do
        painter = create_painter_with_options(width: 50)
        painter.set_width(paintEvent).should eq 50
      end

    end
  end
end