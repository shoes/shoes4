class Shoes
  module Mock
    class Shape
      include Shoes::Mock::CommonMethods

      def line_to(x, y)
      end

      def move_to(x, y)
      end

      def curve_to(*args)
      end
    end
  end
end
