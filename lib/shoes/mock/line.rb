class Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, app, opts = {})
      end

      def move(x, y)
      end
    end
  end
end
