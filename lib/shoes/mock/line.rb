module Shoes
  module Mock
    class Line
      include Shoes::Mock::CommonMethods

      def initialize(dsl, opts = nil)
        @dsl = dsl
      end
    end
  end
end
