# frozen_string_literal: true

class Shoes
  module Mock
    class Shape
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def line_to(_x, _y)
      end

      def move_to(_x, _y)
      end

      def curve_to(*_args)
      end

      def arc_to(*_args)
      end
    end
  end
end
