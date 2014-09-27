class Shoes
  module Mock
    class Oval
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, app)
      end

    end
  end
end
