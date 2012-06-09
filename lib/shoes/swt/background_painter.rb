module Shoes
  module Swt
    module App
      private
      # BackgroundPainter paints and repaints Shoes.app's background(s).
      # It is only used if the user supplies any parameters other than the color,
      # such as :width or :height.
      class BackgroundPainter
        include org.eclipse.swt.events.PaintListener
        attr_accessor :options, :color

        def initialize(*opts, app)
          @app = app
          self.options = opts[0][1]         
          self.color   = opts[0][0]
        end

        def paintControl(e)
          coords = calculate_coords e
          e.gc.setBackground(color.to_native) 
          e.gc.fillRectangle(coords[:x], coords[:y], coords[:width], coords[:height])
        end

        def calculate_coords(e)
          coords = Hash.new
          x      = 0 
          y      = 0
          width  = e.width
          height = e.height

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
