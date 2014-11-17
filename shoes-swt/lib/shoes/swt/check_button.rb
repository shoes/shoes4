class Shoes
  module Swt
    class CheckButton < SwtButton
      include Common::Child

      def initialize(dsl, parent, type)
        super(dsl, parent, type)
      end

      def checked?
        @real.get_selection
      end

      def checked=(bool)
        @real.set_selection bool
      end
    end
  end
end
