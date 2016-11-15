class Shoes
  module Mock
    class Slot
      include Shoes::Mock::CommonMethods
      include Shoes::Mock::Clickable

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
      end

      def remove
      end

      attr_reader :dsl
    end

    class Stack < Slot; end
    class Flow < Slot; end
  end
end
