class Shoes
  module Mock
    class Progress
      include Shoes::Mock::CommonMethods

      def initialize(*_)
        # SWT backend sets a size, so mimic that in the mock
        super
        @dsl.width ||= 140
      end

      def fraction=(_fraction)
      end
    end
  end
end
