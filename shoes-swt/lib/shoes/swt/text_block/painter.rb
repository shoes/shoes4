class Shoes
  module Swt
    class TextBlock
      class Painter
        include ::Swt::Events::PaintListener
        include Common::Resource

        attr_reader :app

        def initialize(dsl)
          @dsl = dsl
        end

        def paintControl(paint_event)
          # See #636 for discussion, contents_alignment may not run or if the
          # space is very narrow we might squish things down to be very narrow.
          # If paint is triggered then, code later on will crash.
          return if @dsl.hidden? ||
                    @dsl.gui.segments.nil? ||
                    @dsl.gui.segments.empty?

          reset_graphics_context(paint_event.gc)
          @dsl.gui.segments.paint_control(paint_event.gc)
        end
      end
    end
  end
end
