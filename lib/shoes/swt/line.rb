module Shoes
  module Swt
    class Line
      include Common::Stroke
      include Common::Resource

      # @param [Hash] opts Options
      #   Must be provided if this shape is responsible for
      #   drawing itself. Omit if this shape is part of another shape.
      def initialize(dsl, opts = nil)
        @dsl = dsl
        if opts
          @container = opts[:app].gui.real
          default_paint_callback = lambda do |event|
            gc = event.gc
            gcs_reset gc
            gc.set_antialias ::Swt::SWT::ON
            gc.set_foreground self.stroke
            gc.set_line_width self.strokewidth
            gc.draw_line(dsl.left, dsl.top, dsl.right, dsl.bottom)
          end
          @paint_callback = opts[:paint_callback] || default_paint_callback
          @container.add_paint_listener(@paint_callback)
        end
      end

      attr_reader :dsl
      attr_reader :container, :element
      attr_reader :paint_callback
    end
  end
end
