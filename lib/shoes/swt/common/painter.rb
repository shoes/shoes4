module Shoes
  module Swt
    module Common
      class Painter
        include Resource

        def initialize(obj)
          @obj = obj
        end

        def paint_control(event)
          gc = event.gc
          gcs_reset gc
          gc.set_antialias ::Swt::SWT::ON
          gc.set_background @obj.fill
          gc.set_alpha @obj.fill_alpha
          fill gc
          gc.set_foreground @obj.stroke
          gc.set_alpha @obj.stroke_alpha
          gc.set_line_width @obj.strokewidth
          draw gc
        end

        def fill(gc)
          raise "Must be implemented by subclass"
        end

        def draw(gc)
          raise "Must be implemented by subclass"
        end
      end
    end
  end
end
