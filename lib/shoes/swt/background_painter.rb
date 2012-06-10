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
          x      = 0 
          y      = 0
          width  = paintEvent.width
          height = paintEvent.height

          if options.has_key? :radius
            width  = 2*options[:radius]
            height = width
          end

          width  = options[:width]  if options.has_key? :width
          height = options[:height] if options.has_key? :height

          if options.has_key? :top
            y       = options[:top]
            height -= options[:top]
          end
          if options.has_key? :bottom
            height -= options[:bottom]
          end
          if options.has_key? :left
            x     += options[:left]
            width -= options[:left]
          end
          if options.has_key? :right
            width -= options[:right]
          end
          coords[:x]=x; coords[:y]=y; coords[:width]=width; coords[:height]=height
          coords
        end
      end
    end
  end
end
