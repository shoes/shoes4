module Shoes
  module Swt
    class Oval
      # opts must be provided if this shape is responsible for
      # drawing itself. If this shape is part of another shape, then
      # opts should be empty
      #
      # @param [Shoes::Oval] dsl The dsl object to provide gui for
      # @param [Hash] opts Options
      # @todo This (mostly) duplicates Shoes::Swt::Line#gui_init
      # @todo Figure out what is the `@real` object here
      def initialize(dsl, opts = {})
        @dsl = dsl
        @container = opts[:container]
        @paint_callback = lambda do |event|
          gc = event.gc
          gc.set_antialias ::Swt::SWT::ON
          gc.set_background self.fill.to_native
          gc.fill_oval(@dsl.left, @dsl.top, @dsl.width, @dsl.height)
          gc.set_foreground self.stroke.to_native
          gc.set_line_width self.style[:strokewidth]
          gc.draw_oval(@dsl.left, @dsl.top, @dsl.width, @dsl.height)
        end
        @container.add_paint_listener(@paint_callback)
      end

      def fill
        @dsl.fill
      end

      def stroke
        @dsl.stroke
      end

      def style
        @dsl.style
      end

      attr_reader :container
      attr_reader :paint_callback
    end
  end
end
