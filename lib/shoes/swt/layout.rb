class Shoes
  module Swt
    class ShoesLayout < ::Swt::Widgets::Layout

      attr_accessor :gui_app

      def layout(*dontcare)
        dsl_app = @gui_app.dsl
        height = dsl_app.height
        scrollable_height = contents_alignment dsl_app.top_slot
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
        vertical_bar.setIncrement height / 2
      end

      def set_gui_location
        location   = @gui_app.real.getLocation
        location.y = 0
        @gui_app.real.setLocation location
      end


      def contents_alignment slot
        x, y = slot.left.to_i, slot.top.to_i
        max = TopHeightData.new
        max.top, max.height = y, 0
        slot_height, slot_top = 0, y

        slot.contents.each do |ele|
          next if ele.is_a?(::Shoes::Background) or ele.is_a?(::Shoes::Border)
          tmp = max
          max = ele.positioning x, y, max
          x, y = ele.left + ele.width, ele.top + ele.height
          unless max == tmp
            slot_height = max.top + max.height - slot_top
          end
        end
        slot_height
      end

      TopHeightData = Struct.new(:top, :height)
    end
  end
end
