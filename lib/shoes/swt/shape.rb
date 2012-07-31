module Shoes
  module Swt
    # The Swt implementation of a Shoes::Shape
    class Shape
      include Common::Fill
      include Common::Stroke
      include Common::Resource

      # Creates a new Shoes::Swt::Shape
      #
      # @param [Shoes::Shape] dsl The dsl object to provide gui for
      # @param [Hash] opts Initialization options
      #   If this shape is part of another shape (i.e. it is not responsible
      #   for drawing itself), `opts` should be omitted
      def initialize(dsl, opts = nil)
        @dsl = dsl
        if opts
          @container = opts[:app].gui.real
          @element = opts[:element] || ::Swt::Path.new(::Swt.display)
          @paint_callback = lambda do |event|
            gc = event.gc
            gcs_reset gc
            @transform = ::Swt::Transform.new(::Swt.display) unless @transform
            gc.setTransform(@transform)
            gc.set_background self.fill
            gc.fill_path(@element)
            gc.set_antialias ::Swt::SWT::ON
            gc.set_foreground self.stroke
            gc.set_line_width self.strokewidth
            gc.draw_path(@element)
            @transform.dispose
          end
          @container.add_paint_listener(@paint_callback)
        end
      end

      attr_reader :dsl
      attr_reader :container, :element
      attr_reader :paint_callback

      def line_to(x, y)
        @element.line_to(x, y)
      end

      def move_to(x, y)
        @element.move_to(x, y)
      end

      def move(left, top)
        @transform = ::Swt::Transform.new(::Swt.display)
        @transform.translate(left, top)
      end
    end
  end
end
