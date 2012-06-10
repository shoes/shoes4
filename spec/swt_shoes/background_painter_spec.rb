require 'swt_shoes/spec_helper'
APP_WIDTH = 400
APP_HEIGHT = 200

# Helper method
def create_painter(options = {})
  # the "color" and nil parameters should not be accessed
  Shoes::Swt::BackgroundPainter.new ["color", options] , nil
end

# For the given options we expect set_width to return expected
def test_set_width(expected, options)
  painter = create_painter(options)
  painter.set_width(paintEvent).should eq expected
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
        test_set_width(50, width: 50)
      end
      
      it "sets the width to twice the radius if supplied" do
        test_set_width(2*25, radius: 25)
      end
      
      it "sets the width to the width option even if radius is supplied" do
        test_set_width(50, width: 50, radius: 70)
      end
      
      it "sets the width correctly if right and left are supplied" do
        # the purpose is that left and right are the offsets from the borders
        # the method then computes the distance between those 2 offsets
        test_set_width(APP_WIDTH - (30 + 20), left: 20, right: 30)
      end
      
      it "doest not use left and right if width is also supplied" do
        test_set_width(70, left: 20, right: 30, width: 70)
      end
      
      it "sets the width to the app width if no width parameters are supplied" do
        test_set_width(APP_WIDTH, {})
      end

    end
  end
end
