class Shoes
  module Mock
    class Rect
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, app, _opts = {})
        @dsl = dsl
        @app = app
      end

      attr_reader :dsl, :app
    end
  end
end
