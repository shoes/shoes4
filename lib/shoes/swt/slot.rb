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

        # FIXME Should be one of
        # @app = @parent.app
        # include Common::Child
        # if including the module, remove the attr_reader on :app
        @app = @dsl.app.gui
      end

      # needed by Layouter code, but slots are no physical elements so they
      def update_position
      end

      attr_reader :real, :dsl, :parent, :app
    end
    class Flow < Slot; end
    class Stack < Slot; end
  end
end
