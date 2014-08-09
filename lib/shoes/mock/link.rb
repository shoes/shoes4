class Shoes
  module Mock
    class Link
      include Shoes::Mock::CommonMethods

      def initialize(dsl, app, opts = {})
      end

      def click(blk)
      end
    end
  end
end

