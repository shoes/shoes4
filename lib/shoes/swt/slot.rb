module Shoes
  module Swt
    class Slot
      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = parent.real
        @real.getLayout.top_slot ||= self.dsl
        @contents = []
        @parent.dsl.contents << @dsl
      end

      attr_reader :real, :dsl, :parent, :contents, :app, :left, :top, :width, :height
    end
    class Flow < Slot; end
    class Stack < Slot; end
  end
end
