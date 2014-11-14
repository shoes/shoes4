class Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(_dsl, _app, _opts = {})
      end

      def move(_x, _y)
      end
    end
  end
end
