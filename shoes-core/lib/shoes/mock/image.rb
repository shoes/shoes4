class Shoes
  module Mock
    class Image
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      attr_accessor :left, :top

      def initialize(*_)
        # SWT backend sets a size, so mimic that in the mock
        super
        @dsl.width ||= 22
      end

      def update_image
      end
    end
  end
end
