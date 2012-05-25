class MenuPanel < Shoes::Widget
  @@boxes = []
  def initialize(color, args)
    @@boxes << self
    background color
    para link("Box #{@@boxes.length}", :stroke => white, :fill => nil).
      click { visit "/" },
        :margin => 18, :align => "center", :size => 20
    hover { expand }
  end
  def expand
    if self.width < 170
      a = animate 30 do
        @@boxes.each do |b|
          b.width -= 5 if b != self and b.width > 140
        end
        self.width += 5
        a.stop if self.width >= 170
      end
    end
  end
end

Shoes.app :width => 400, :height => 130 do
  style(Link, :underline => nil)
  style(LinkHover, :fill => nil, :underline => nil)
  menu_panel green,  :width => 170, :height => 120, :margin => 4
  menu_panel blue,   :width => 140, :height => 120, :margin => 4
  menu_panel red,    :width => 140, :height => 120, :margin => 4
  menu_panel purple, :width => 140, :height => 120, :margin => 4
end
