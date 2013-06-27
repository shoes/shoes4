require 'shoes/common_methods'
require 'shoes/common/stroke'
require 'shoes/common/style'

module Shoes
  module Swt
    class Curve
      include Common::Stroke
      include Common::Move
      include Common::Toggle
      include Common::Clear

      # @param [Shoes::Curve] the {Shoes::Curve} implemented by this object
      # @param [Shoes::Swt::App] app the {Swt::App} this object belongs to
      def initialize(dsl, app, point_1, control_1, control_2, point_2, opts = {}, &blk)
        @dsl, @app = dsl, app
        @container = @app.real

        @point_1, @control_1, @control_2, @point_2 = point_1, control_1, control_2, point_2

        @angle = opts[:angle] || 0

        @element = ::Swt::Path.new(::Swt.display)
        @element.move_to(point_1.x, point_1.y)
        @element.cubic_to(control_1.x, control_1.y, control_2.x, control_2.y, point_2.x, point_2.y)
        # Use Path::get_bounds to get the extent
        # This may not be optimal for a cubic curve
        bounds = Java::float[4].new
        @element.get_bounds(bounds)
        @left, @top, @width, @height = bounds[0], bounds[1], bounds[2], bounds[3]

        @painter = Painter.new(self)
        @app.add_paint_listener @painter
      end

      attr_reader :dsl
      attr_reader :transform
      attr_reader :left, :top, :width, :height, :angle

      attr_reader :point_1, :control_1, :control_2, :point_2
      attr_reader :element

      class Painter < Common::Painter
        def draw(gc)
          gc.draw_path(@obj.element)
        end

        def fill_setup(gc)
        end
      end
    end
  end
end
