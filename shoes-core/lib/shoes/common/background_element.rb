class Shoes
  module Common
    module BackgroundElement
      def create_dimensions(*_)
        @dimensions = ParentDimensions.new @parent, @style
      end

      def takes_up_space?
        false
      end
    end
  end
end
