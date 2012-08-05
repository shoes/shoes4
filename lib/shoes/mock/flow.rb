module Shoes
  module Mock
    class Flow
      def dsl
        A.new
      end

      private
      class A
        def contents
          []
        end
      end

    end
  end
end
