class Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, opts = {})
      end


      def move(x, y)
      end
    end
  end
end
