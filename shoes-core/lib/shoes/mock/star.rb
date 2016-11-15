class Shoes
  module Mock
    class Star
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, app)
        @dsl = dsl
        @app = app
      end

      attr_reader :dsl, :app
    end
  end
end
