class Shoes
  module Swt
    class Slot
      include Common::Container
      include Common::Clickable
      include Common::Toggle

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = parent.real
      end

      # needed by Layouter code, but slots are no physical elements so they
      def update_position
      end

      attr_reader :real, :dsl, :parent
    end
    class Flow < Slot; end
    class Stack < Slot; end
  end
end
