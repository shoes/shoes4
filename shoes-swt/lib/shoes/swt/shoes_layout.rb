class Shoes
  module Swt
    class ShoesLayout < ::Swt::Widgets::Layout
      attr_accessor :gui_app

      def layout(*_dontcare)
        height, scroll_height, is_scrolling = gather_height_info(@gui_app.dsl)
        set_heights(@gui_app.dsl, @gui_app.real, height, scroll_height)

        if is_scrolling
          show_scrollbar(vertical_scrollbar, height, scroll_height)
        else
          hide_scrollbar(vertical_scrollbar, @gui_app.real)
        end
      end

      private

      def gather_height_info(dsl_app)
        height = dsl_app.height
        scroll_height = dsl_app.top_slot.contents_alignment
        [height, scroll_height, scroll_height > height]
      end

      def set_heights(dsl_app, real_app, height, scroll_height)
        maximum_height = [height, scroll_height].max
        set_real_size(dsl_app, real_app, maximum_height)
        set_top_slot_size(dsl_app, maximum_height)
      end

      def set_real_size(dsl_app, real_app, maximum_height)
        size = real_app.compute_trim 0, 0, dsl_app.width, maximum_height
        real_app.set_size(size.width, size.height)
      end

      def set_top_slot_size(dsl_app, maximum_height)
        dsl_app.top_slot.width  = dsl_app.width
        dsl_app.top_slot.height = maximum_height
      end

      def show_scrollbar(scrollbar, height, scroll_height)
        scrollbar.visible   = true
        scrollbar.thumb     = height * height / scroll_height
        scrollbar.maximum   = scroll_height - height + scrollbar.thumb
        scrollbar.increment = 10
      end

      def hide_scrollbar(scrollbar, real_app)
        scrollbar.visible = false
        location   = real_app.location
        location.y = 0
        real_app.location = location
      end

      def vertical_scrollbar
        @gui_app.shell.vertical_bar
      end
    end
  end
end
