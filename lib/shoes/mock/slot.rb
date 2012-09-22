module Shoes
  module Mock
    class Slot
      def dsl
        dsl = Struct.new(:contents).new([])
      end
    end

    class Stack < Slot; end
    class Flow < Slot; end
  end
end
