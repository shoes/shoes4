class Shoes
  module Mock
    class Link
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(_dsl, _app, _opts = {})
      end
    end
  end
end
