class Shoes
  module Mock
    class Progress
      include Shoes::Mock::CommonMethods

      def fraction=(_fraction)
      end
    end
  end
end
