class Shoes
  module Mock
    class Button
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, _parent)
        # For whatever reason the SWT button sets sizes back during initialize
        # and at least one test (for the ask dialog which runs a full Shoes.app)
        # relies on that sizing being set for positioning logic to run.
        #
        # Best I can tell, it doesn't matter *what* the values are, as long as
        # they're there.
        dsl.width  = 0 unless dsl.width
        dsl.height = 0 unless dsl.height
      end

      def enabled(_value)
      end
    end
  end
end
