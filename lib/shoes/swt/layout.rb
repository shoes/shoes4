module Shoes::Swt
  class ShoesLayout < Swt::Widgets::Layout
    attr_accessor :top_slot

    def layout *args
      contents_alignment @top_slot
    end

    def contents_alignment slot
      x, y = slot.left.to_i, slot.top.to_i
      max = Struct.new(:top, :height).new
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
  end
end
