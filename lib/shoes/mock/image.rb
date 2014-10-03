class Shoes
  module Mock
    class Image
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      attr_accessor :left, :top

      def update_image
      end
    end
  end
end
