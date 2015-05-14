class Shoes
  module Mock
    class Gif
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      attr_accessor :left, :top

      def update_gif
      end
    end
  end
end
