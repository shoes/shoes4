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

      def paintControl(paintEvent)
        coords = calculate_coords paintEvent
        paintEvent.gc.setBackground(color.to_native)
        paintEvent.gc.fillRectangle(coords[:x], coords[:y], coords[:width], coords[:height])
      end

      def calculate_coords(paintEvent)
        coords = Hash.new
        puts paintEvent.width
        puts paintEvent.height

        coords[:width] = set_width(paintEvent)
        coords[:height] = set_height(paintEvent)
        coords[:x] = set_x(paintEvent, coords[:width])
        coords[:y] = set_y(paintEvent, coords[:height])

        coords
      end

      def set_width(paintEvent)
        if options.has_key? :width
          options[:width]
        elsif options.has_key? :radius
          2*options[:radius]
        elsif options.has_key?(:left) && options.has_key?(:right)
          paintEvent.width - (options[:right] + options[:left])
        else
          paintEvent.width
        end
      end

      def set_height(paintEvent)
        if options.has_key? :height
          height = options[:height]
        elsif options.has_key? :radius
          2*options[:radius]
        elsif options.has_key?(:top) && options.has_key?(:bottom)
          paintEvent.height - (options[:top] + options[:bottom])
        else
          paintEvent.height
        end
      end

      def set_x(paintEvent, width)
        if options.has_key? :left
          options[:left]
        # if width is != paintEvent.width then it was altered in some way and we
        # have to adjust. Otherwise, 0 is a valid answer.
        elsif options.has_key?(:right) && (width != paintEvent.width) 
          paintEvent.width - (width + options[:right])
        else
          0
        end
      end

      def set_y(paintEvent, height)
        if options.has_key? :top
          options[:top]
        # height is != the paintEvent.height then it was altered and we need to adjust
        elsif options.has_key?(:bottom) && (height != paintEvent.height)
          paintEvent.height - (height + options[:bottom])
        else
          0
        end
      end

    end
  end
end
