class Shoes
  module Mock
    class Arc
      include Shoes::Mock::Clickable
      def initialize(dsl, app, opts = {})
      end
    end
  end
end
