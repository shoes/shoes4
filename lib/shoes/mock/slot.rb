class Shoes
  module Mock
    class Slot
      include Shoes::Mock::Clickable

      def initialize(dsl, parent)
        @dsl, @parent = dsl, parent
      end

      attr_reader :dsl
    end

    class Stack < Slot; end
    class Flow < Slot; end
  end
end
