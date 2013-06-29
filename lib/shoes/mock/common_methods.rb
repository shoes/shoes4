class Shoes
  module Mock
    module CommonMethods
      def initialize(dsl, *args)
      end

      def move(left, top)
        @left, @top = left, top
      end
    end
  end
end
