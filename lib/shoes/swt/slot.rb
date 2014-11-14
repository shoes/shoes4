class Shoes
  module Swt
    class Slot
      include Common::Container
      include Common::Clickable
      include Common::Visibility

      attr_reader :real, :dsl, :parent, :app

      def initialize(dsl, parent)
        @dsl = dsl
        @parent = parent
        @real = parent.real

        @app = @parent.app
      end

      # needed by Layouter code, but slots are no physical elements so they
      def update_position
      end

      # This is more like a temporary work around until slots have a real
      # backend representations that can just hide their contents all together
      # I decided to put this logic in the backend since the hiding is a backend
      # responsibility, although this is more DSL code
      # #904 #905
      def update_visibility
        if dsl.hidden?
          dsl.contents.each &:hide
        else
          dsl.contents.each &:show
        end
      end
    end
    class Flow < Slot; end
    class Stack < Slot; end
  end
end
