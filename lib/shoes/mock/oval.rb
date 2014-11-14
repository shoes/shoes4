class Shoes
  module Mock
    class Oval
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(_dsl, _app)
      end
    end
  end
end
