module Shoes
  module Swt
    class Arc
      include Common::Fill
      include Common::Stroke

      # Creates a new Shoes::Swt::Arc
      #
      # @param [Shoes::Arc] dsl The DSL object represented by this implementation
      # @parem [Shoes::Swt::App] app The implementation object of the Shoes app
      def initialize(dsl, app, left, top, width, height, opts = {})
        @dsl, @app = dsl, app
        @left, @top, @width, @height = left, top, width, height
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
            gc.fill_arc(translated_left, translated_top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
          else
            path = ::Swt::Path.new(::Swt.display)
            path.add_arc(translated_left, translated_top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
            gc.fill_path(path)
          end
        end

        def draw(gc)
          gc.draw_arc(translated_left, translated_top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
        end

        private
        def translated_left
          translated_coord(@obj.left, @obj.width)
        end

        def translated_top
          translated_coord(@obj.top, @obj.height)
        end

        def translated_coord(coord, size)
          Integer(coord - size * 0.5)
        end
      end
    end
  end
end
