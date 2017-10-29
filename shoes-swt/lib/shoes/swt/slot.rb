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

      def update_visibility
        @scroll.set_visible(@dsl.scroll && @dsl.scroll_max.positive?)

        if @dsl.scroll
          scrollbar_width = 20

          @scroll.selection = @dsl.scroll_top
          @scroll.maximum = @dsl.scroll_max
          @scroll.set_bounds @dsl.element_right - scrollbar_width + 1,
                             @dsl.element_top,
                             scrollbar_width,
                             @dsl.element_height
        end
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
