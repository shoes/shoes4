module Shoes
  module Mock
    class Curve
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, p1, p2, p3, opts = {})
        @dsl, @app = dsl, app
        @p1, @p2, @p3 = p1, p2, p3
      end

      attr_reader :p1, :p2, :p3
    end
  end
end
