module Shoes
  module Swt
    module App
      private
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

          coords[:width] = set_width(paintEvent)
          coords[:height] = set_height(paintEvent, coords[:width])
          coords[:y] = set_y
          coords[:x] = set_x

          coords
        end

        def set_width(paintEvent)
          width = set_initial_width(paintEvent)
          width = adjust_width(width)
          width
        end

        def set_initial_width(paintEvent)
          if options.has_key? :width
            width = options[:width]
          else
            width = paintEvent.width
            width = 2*options[:radius] if options.has_key? :radius
          end
          width
        end

        def adjust_width(width)
          width -= options[:left] if options.has_key? :left
          width -= options[:right] if options.has_key? :right
          width
        end

        def set_height(paintEvent, width)
          height = set_initial_height(paintEvent, width)
          height = adjust_height(height)
          height
        end

        def set_initial_height(paintEvent, width)
          if options.has_key? :height
            height = options[:height]
          elsif options.has_key? :radius
            height = width
          else
            height = paintEvent.height
          end
          height
        end

        def adjust_height(height)
          height -= options[:bottom] if options.has_key? :bottom
          height -= options[:top] if options.has_key? :top
          height
        end

        def set_x
          x = 0
          x += options[:left] if options.has_key?(:left)
          x
        end

        def set_y
          if options.has_key? :top
            y = options[:top]
          else
            y = 0
          end
          y
        end

      end
    end
  end
end
