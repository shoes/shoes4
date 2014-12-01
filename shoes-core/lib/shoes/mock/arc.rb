class Shoes
  module Mock
    class Arc
      include Shoes::Mock::Clickable
      def initialize(_dsl, _app, _opts = {})
      end
    end
  end
end
