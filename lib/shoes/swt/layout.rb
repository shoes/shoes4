module Shoes::Swt
  class ShoesLayout < Swt::Widgets::Layout
    attr_accessor :top_slot

    def layout *args
      app = @top_slot.app
      w, h = app.width, app.height
      scrollable_height = contents_alignment @top_slot
      app = app.gui
      app.real.setSize w, [scrollable_height, h].max
      vb = app.shell.getVerticalBar
      vb.setVisible(scrollable_height > h)
      if scrollable_height > h
        vb.setThumb h * h / scrollable_height
        vb.setMaximum scrollable_height - h + vb.getThumb
        vb.setIncrement h / 2
      else
        location = app.real.getLocation
        location.y = 0
        app.real.setLocation location
      end
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
