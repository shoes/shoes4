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

        @scroll = ::Swt::Widgets::Slider.new(@app.real, ::Swt::SWT::VERTICAL)
        @scroll.add_selection_listener do |_event|
          update_scroll
        end
      end

      # needed by Layouter code, but slots are no physical elements so they
      def update_position
      end

      def update_scroll
        @dsl.scroll_top = @scroll.selection
      end

      # This is more than the scrollbar is expected to be on any OS
      SCROLLBAR_MAX_WIDTH = 20

      # For some reason, if we set max to match, you can't get past last 10!
      SCROLLBAR_PADDING = 10

      def update_visibility
        @scroll.set_visible(@dsl.scroll && @dsl.scroll_max.positive?)

        return unless @dsl.scroll

        @scroll.selection = @dsl.scroll_top
        @scroll.maximum = @dsl.scroll_max + SCROLLBAR_PADDING
        @scroll.set_bounds @dsl.element_right - SCROLLBAR_MAX_WIDTH + 1,
                           @dsl.element_top,
                           SCROLLBAR_MAX_WIDTH,
                           @dsl.element_height
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
