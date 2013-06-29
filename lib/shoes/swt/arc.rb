class Shoes
  module Swt
    class Arc
      include Common::Fill
      include Common::Stroke
      include Common::Clear

      # Creates a new Shoes::Swt::Arc
      #
      # @param [Shoes::Arc] dsl The DSL object represented by this implementation
      # @param [Shoes::Swt::App] app The implementation object of the Shoes app
      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @width, @height = left, top, width, height
        @container = @app.real
        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :left, :top, :width, :height

      def angle1
        radians_to_degrees dsl.angle1
      end

      def angle2
        radians_to_degrees dsl.angle2
      end

      def wedge?
        @dsl.wedge?
      end

      private
      def radians_to_degrees(radians)
        radians * 180 / ::Shoes::PI
      end

      public
      class Painter < Common::Painter
        def fill(gc)
          if (@obj.wedge?)
            gc.fill_arc(@obj.left, @obj.top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
          else
            path = ::Swt::Path.new(::Swt.display)
            path.add_arc(@obj.left, @obj.top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
            gc.fill_path(path)
          end
        end

        def draw(gc)
          sw = gc.get_line_width
          gc.draw_arc(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw, @obj.angle1, @obj.angle2 * -1)
        end
      end
    end
  end
end
