# frozen_string_literal: true
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

      def update_visibility
        # No-op since we aren't a real backend, but need to prevent the
        # shared visibility behavior of tweaking @real's visibility
      end

      def redraw_target
        @dsl
      end

      def remove
        app.click_listener.remove_listeners_for(dsl)
      end
    end

    class Flow < Slot; end
    class Stack < Slot; end
    class Widget < Slot; end
  end
end
