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
          unless @obj.dsl.hidden
            gc.set_antialias ::Swt::SWT::ON
            gc.set_transform(@obj.transform)
            fill gc if fill_setup(gc)
            draw gc if draw_setup(gc)
          end
        end

        # Override in subclass and return something falsy if not using fill
        def fill_setup(gc)
          @obj.apply_fill(gc)
        end

        # Implement in subclass
        def fill(gc)
        end

        # Override in subclass and return something falsy if not using draw
        def draw_setup(gc)
          @obj.apply_stroke(gc)
        end

        # Implement in subclass
        def draw(gc)
        end

        def set_position_and_size
          @obj.left = @obj.dsl.parent.left
          @obj.top = @obj.dsl.parent.top
          @obj.width = @obj.opts[:width] || @obj.dsl.parent.width
          @obj.height = @obj.opts[:height] || @obj.dsl.parent.height
        end
      end
    end
  end
end
