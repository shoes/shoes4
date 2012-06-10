module Shoes
  module Swt
    class Oval
      include Shoes::Swt::Common::Fill
      include Shoes::Swt::Common::Stroke

      # opts must be provided if this shape is responsible for
      # drawing itself. If this shape is part of another shape, then
      # opts should be empty
      #
      # @param [Shoes::Oval] dsl The dsl object to provide gui for
      # @param [Hash] opts Options
      # @todo This (mostly) duplicates Shoes::Swt::Line#gui_init
      # @todo Figure out what is the `@real` object here
      def initialize(dsl, opts = nil)
        @dsl = dsl
        if opts
          @container = opts[:app].gui_container
          @paint_callback = lambda do |event|
            gc = event.gc
            gc.set_antialias ::Swt::SWT::ON
            gc.set_background self.fill
            gc.fill_oval(@dsl.left, @dsl.top, @dsl.width, @dsl.height)
            gc.set_foreground self.stroke
            gc.set_line_width self.strokewidth
            gc.draw_oval(@dsl.left, @dsl.top, @dsl.width, @dsl.height)
          end
          @container.add_paint_listener(@paint_callback)
        end
      end

      attr_reader :dsl
      attr_reader :container
      attr_reader :paint_callback
    end
  end
end
