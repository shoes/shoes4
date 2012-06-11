module Shoes
  module Swt
    # BackgroundPainter paints and repaints Shoes.app's background(s).
    # It is only used if the user supplies any parameters other than the color,
    # such as , :right, :left, :width or :height.
    class BackgroundPainter
      include org.eclipse.swt.events.PaintListener
      attr_accessor :options, :color

      def initialize(*opts, app)
        @app = app
        self.options = opts[0][1]
        self.color   = opts[0][0]
        self.color = options[:fill] if options.has_key? :fill
      end

      def paintControl(paint_event)
        coords = calculate_coords paint_event
        paint_event.gc.setBackground(color.to_native)
        paint_event.gc.fillRectangle(coords[:x], coords[:y], coords[:width], coords[:height])
      end

      def calculate_coords(paint_event)
        coords = Hash.new

        coords[:width] = set_width(paint_event)
        coords[:height] = set_height(paint_event)
        coords[:x] = set_x(paint_event, coords[:width])
        coords[:y] = set_y(paint_event, coords[:height])

        coords
      end

      def set_width(paint_event)
        if options.has_key? :width
          options[:width]
        elsif options.has_key? :radius
          2*options[:radius]
        elsif options.has_key?(:left) && options.has_key?(:right)
          paint_event.width - (options[:right] + options[:left])
        else
          paint_event.width
        end
      end

      def set_height(paint_event)
        if options.has_key? :height
          height = options[:height]
        elsif options.has_key? :radius
          2*options[:radius]
        elsif options.has_key?(:top) && options.has_key?(:bottom)
          paint_event.height - (options[:top] + options[:bottom])
        else
          paint_event.height
        end
      end

      def set_x(paint_event, width)
        if options.has_key? :left
          options[:left]
        # if width is != paint_event.width then it was altered in some way and we
        # have to adjust. Otherwise, 0 is a valid answer.
        elsif options.has_key?(:right) && (width != paint_event.width)
          paint_event.width - (width + options[:right])
        else
          0
        end
      end

      def set_y(paint_event, height)
        if options.has_key? :top
          options[:top]
        # height is != the paint_event.height then it was altered and we need to adjust
        elsif options.has_key?(:bottom) && (height != paint_event.height)
          paint_event.height - (height + options[:bottom])
        else
          0
        end
      end

    end
  end
end
