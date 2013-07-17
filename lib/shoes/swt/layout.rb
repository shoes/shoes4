class Shoes
  module Swt
    class ShoesLayout < ::Swt::Widgets::Layout

      attr_accessor :gui_app

      def layout *args
        dsl_app = @gui_app.dsl
        w, h = dsl_app.width, dsl_app.height
        scrollable_height = contents_alignment dsl_app.top_slot
        size = @gui_app.real.compute_trim 0, 0, w, [scrollable_height, h].max
        @gui_app.real.set_size(size.width, size.height)
        vb = @gui_app.shell.getVerticalBar
        vb.setVisible(scrollable_height > h)
        if scrollable_height > h
          vb.setThumb h * h / scrollable_height
          vb.setMaximum scrollable_height - h + vb.getThumb
          vb.setIncrement h / 2
        else
          location = @gui_app.real.getLocation
          location.y = 0
          @gui_app.real.setLocation location
        end
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
