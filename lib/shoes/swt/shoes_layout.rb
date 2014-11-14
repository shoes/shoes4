class Shoes
  module Swt
    class ShoesLayout < ::Swt::Widgets::Layout
      attr_accessor :gui_app

      def layout(*_dontcare)
        dsl_app = @gui_app.dsl
        height = dsl_app.height
        scrollable_height = dsl_app.top_slot.contents_alignment
        set_gui_size(height, scrollable_height)

        vertical_bar = @gui_app.shell.getVerticalBar
        vertical_bar.setVisible(scrollable_height > height)
        if scrollable_height > height
          handle_scroll_bar(vertical_bar, height, scrollable_height)
        else
          set_gui_location
        end
      end

      private

      def set_gui_size(height, scrollable_height)
        width          = @gui_app.dsl.width
        maximum_height = [scrollable_height, height].max
        size           = @gui_app.real.compute_trim 0, 0, width, maximum_height
        @gui_app.real.set_size(size.width, size.height)
      end

      def handle_scroll_bar(vertical_bar, height, scrollable_height)
        vertical_bar.setThumb height * height / scrollable_height
        vertical_bar.setMaximum scrollable_height - height + vertical_bar.getThumb
        vertical_bar.increment = 10
      end

      def set_gui_location
        location   = @gui_app.real.getLocation
        location.y = 0
        @gui_app.real.setLocation location
      end
    end
  end
end
