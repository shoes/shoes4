module Shoes
  module Swt
    class Arc
      include Common::Fill
      include Common::Stroke

      # @note This class expects opts[:app] to be a Shoes::Swt::App. Other shapes expect a
      #       Shoes::App. It's preferable to pass a Shoes::Swt::App because it maintains the
      #       separation between layers. If this attempt is successful, other shapes should
      #       follow suit (Line, Oval, Shape)
      # @note This class uses the private #fill_shape and #draw_shape methods. These should be
      #       the only difference in shape-drawing. Other classes should follow suit, and use a 
      #       common paint_callback lambda.
      def initialize(dsl, opts)
        @dsl = dsl
        @left = opts[:left]
        @top = opts[:top]
        @width = opts[:width]
        @height = opts[:height]
        @container = opts[:app].real
        @container.add_paint_listener Painter.new(self)
      end

      attr_reader :dsl
      attr_reader :left, :top, :width, :height

      def angle1
        radians_to_degrees dsl.angle1
      end

      def angle2
        radians_to_degrees dsl.angle2
      end

      def fill_alpha
        dsl.fill.alpha
      end

      def stroke_alpha
        dsl.stroke.alpha
      end

      private
      def radians_to_degrees(radians)
        radians * 180 / ::Shoes::PI
      end

      public
      class Painter
        include Common::Resource

        def initialize(obj)
          @obj = obj
        end

        def fill(gc)
          gc.fill_arc(translated_left, translated_top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
        end

        def draw(gc)
          gc.draw_arc(translated_left, translated_top, @obj.width, @obj.height, @obj.angle1, @obj.angle2 * -1)
        end

        def paint_control(event)
          gc = event.gc
          gcs_reset gc
          gc.set_antialias ::Swt::SWT::ON
          gc.set_background @obj.fill
          gc.set_alpha @obj.fill_alpha
          fill gc
          gc.set_foreground @obj.stroke
          gc.set_alpha @obj.stroke_alpha
          gc.set_line_width @obj.strokewidth
          draw gc
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
