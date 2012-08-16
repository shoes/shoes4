module Shoes
  module Swt
    class Arc
      # @note This class expects opts[:app] to be a Shoes::Swt::App. Other shapes expect a
      #       Shoes::App. It's preferable to pass a Shoes::Swt::App because it maintains the
      #       separation between layers. If this attempt is successful, other shapes should
      #       follow suit (Line, Oval, Shape)
      # @note This class uses the private #fill_shape and #draw_shape methods. These should be
      #       the only difference in shape-drawing. Other classes should follow suit, and use a 
      #       common paint_callback lambda.
      def initialize(dsl, opts)
        @container = opts[:app].real
        @paint_callback = lambda do |event|
          gc = event.gc
          gcs_reset gc
          gc.set_antialias ::Swt::SWT::ON
          gc.set_background self.fill
          gc.setAlpha self.fill.alpha
          fill_shape(gc)
          gc.set_foreground self.stroke
          gc.setAlpha self.stroke.alpha
          gc.set_line_width self.strokewidth
          draw_shape(gc)
        end
        @container.add_paint_listener @paint_callback
      end

      private
      def fill_shape(gc)
        raise "not implemented"
      end

      def draw_shape(gc)
        raise "not implemented"
      end
    end
  end
end
