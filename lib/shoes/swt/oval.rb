module Shoes
  module Swt
    class Oval
      include Common::Fill
      include Common::Stroke
      include Common::Move
      include Common::Resource

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
        @left, @top, @width, @height = @dsl.left, @dsl.top, @dsl.width, @dsl.height
        @fill, @stroke = @dsl.fill, @dsl.stroke
        if opts
          @container = opts[:app].gui.real
          @paint_callback = lambda do |event|
            gc = event.gc
            gcs_reset gc
            gc.set_antialias ::Swt::SWT::ON
            gc.set_background self.fill
            gc.setAlpha @fill.alpha
            gc.fill_oval(@left, @top, @width, @height)
            gc.set_foreground self.stroke
            gc.setAlpha @stroke.alpha
            gc.set_line_width self.strokewidth
            gc.draw_oval(@left, @top, @width, @height)
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
