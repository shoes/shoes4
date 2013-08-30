class Shoes
  module Swt
    class Arc
      extend Forwardable

      include Common::Fill
      include Common::Stroke
      include Common::Clear

      attr_reader :dsl, :transform
      def_delegators :dsl, :left, :top, :width, :height, :wedge?

      # Creates a new Shoes::Swt::Arc
      #
      # @param [Shoes::Arc] dsl The DSL object represented by this implementation
      # @param [Shoes::Swt::App] app The implementation object of the Shoes app
      def initialize(dsl, app, opts = {})
        @dsl = dsl
        @container = app.real
        @painter = Painter.new(self)
        app.add_paint_listener @painter
      end

      def angle1
        radians_to_degrees dsl.angle1
      end

      def angle2
        radians_to_degrees dsl.angle2
      end

      private
      def radians_to_degrees(radians)
        radians * 180 / ::Shoes::PI
      end

      public
      class Painter < Common::Painter
        def fill(graphics_context)
          if (@obj.wedge?)
            graphics_context.fill_arc(@obj.left, @obj.top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
          else
            path = ::Swt::Path.new(::Swt.display)
            path.add_arc(@obj.left, @obj.top, @obj.width, @obj.height,@obj. angle1, @obj.angle2 * -1)
            graphics_context.fill_path(path)
          end
        end

        def draw(graphics_context)
          sw = graphics_context.get_line_width
          graphics_context.draw_arc(@obj.left+sw/2, @obj.top+sw/2, @obj.width-sw, @obj.height-sw, @obj.angle1, @obj.angle2 * -1)
        end
      end
    end
  end
end
