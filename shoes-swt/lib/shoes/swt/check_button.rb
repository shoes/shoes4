class Shoes
  module Swt
    class CheckButton < SwtButton
      def initialize(dsl, app, type)
        super(dsl, app, type)
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
