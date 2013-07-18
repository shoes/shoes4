class Shoes
  module Swt
    class Slot
      include Common::Container
      include Common::Clickable

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @app = parent.app
        @real = parent.real
        @contents = []
        @parent.dsl.contents << @dsl
      end

      attr_reader :real, :dsl, :parent, :contents, :app, :left, :top, :width, :height
    end
    class Flow < Slot; end
    class Stack < Slot; end
  end
end
