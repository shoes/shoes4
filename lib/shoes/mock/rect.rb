class Shoes
  module Mock
    class Rect
      include CommonMethods

      def initialize(dsl, app, opts = {})
        @dsl, @app = dsl, app
      end

      attr_reader :dsl, :app
    end
  end
end
