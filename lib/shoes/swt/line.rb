module Shoes
  module Swt
    class Line
      include Common::Stroke
      include Common::Move
      include Common::Toggle
      include Common::Clear

      # @param [Shoes::Line] dsl The Shoes::Line implemented by this object
      # @param [Shoes::Point] point_a One endpoint of the line
      # @param [Shoes::Point] point_b The other endpoint of the line
      # @param [Hash] opts Options
      def initialize(dsl, app, point_a, point_b, opts = {})
        @dsl, @app = dsl, app

        # Move
        @container = @app.real

        # Represent the enclosing box of the line as starting at (0,0), then
        # apply a transform translation to draw it in the proper place.
        @left = point_a.left(point_b)
        @top = point_a.top(point_b)
        @width = point_a.width(point_b)
        @height = point_a.height(point_b)
        @point_a = point_a.to(-@left, -@top)
        @point_b = point_b.to(-@left, -@top)
        @transform = ::Swt::Transform.new(::Swt.display)
        # Array to hold transform elements
        @te = Java::float[6].new
        move @left, @top

        @painter = Painter.new(self)
        @app.add_paint_listener(@painter)
      end

      attr_reader :dsl, :app
      attr_reader :point_a, :point_b
      attr_reader :left, :top, :width, :height, :angle
      attr_reader :transform

      # @override Common::Move#move
      def move(x, y)
        unless @container.disposed?
          @container.redraw left, top, width, height, false
          @container.redraw x, y, width, height, false
        end
        @transform.get_elements @te
        @transform.set_elements @te[0], @te[1], @te[2], @te[3], x, y
        @left, @top = x, y
        self
      end

      class Painter < Common::Painter
        def draw(gc)
          point_a, point_b = @obj.point_a, @obj.point_b
          gc.draw_line(point_a.x, point_a.y, point_b.x, point_b.y)
        end

        # Don't do fill setup
        def fill_setup(gc)
        end
      end
    end
  end
end
