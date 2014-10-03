class Shoes
  module Mock
    class Link
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, app, opts = {})
      end
      
    end
  end
end
