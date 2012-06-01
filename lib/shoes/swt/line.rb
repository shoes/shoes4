module Shoes
  module Swt
    module Line
      attr_reader :gui_container, :gui_element
      attr_reader :gui_paint_callback

      def gui_init
        # @gui_opts must be provided if this shape is responsible for
        # drawing itself. If this shape is part of another shape, then
        # @gui_opts should be nil
        if @gui_opts
          @gui_container = @gui_opts[:container]
          default_paint_callback = lambda do |event|
            gc = event.gc
            gc.set_antialias ::Swt::SWT::ON
            gc.set_foreground self.stroke.to_native
            gc.set_line_width self.style[:strokewidth]
            gc.draw_line(@left, @top, right, bottom)
          end
          @gui_paint_callback = @gui_opts[:paint_callback] || default_paint_callback
          @gui_container.add_paint_listener(@gui_paint_callback)
        end
      end
    end
  end
end

module Shoes
  class Line
    include Shoes::Swt::Line
  end
end
