class Shoes
  module Mock
    class Star
      include CommonMethods

      def initialize(dsl, app)
        @dsl, @app = dsl, app
      end

      attr_reader :dsl, :app
    end
  end
end
