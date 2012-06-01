module Shoes
  module Swt
    module Oval
      attr_reader :gui_container, :gui_element
      attr_reader :gui_paint_callback

      # FIXME: This (mostly) duplicates Shoes::Swt::Line#gui_init
      def gui_init
        # @gui_opts must be provided if this shape is responsible for
        # drawing itself. If this shape is part of another shape, then
        # @gui_opts should be nil
        if @gui_opts
          @gui_container = @gui_opts[:container]
          @gui_paint_callback = lambda do |event|
            gc = event.gc
            gc.set_antialias ::Swt::SWT::ON
            gc.set_background self.fill.to_native
            gc.fill_oval(@left, @top, @width, @height)
            gc.set_foreground self.stroke.to_native
            gc.set_line_width self.style[:strokewidth]
            gc.draw_oval(@left, @top, @width, @height)
          end
          @gui_container.add_paint_listener(@gui_paint_callback)
        end
      end
    end
  end
end

module Shoes
  class Oval
    include Shoes::Swt::Oval
  end
end
