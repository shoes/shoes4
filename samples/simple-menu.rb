class MenuPanel < Shoes::Widget
  @@boxes = []

  # Handling width against internal stack until widget widths are fixed
  # https://github.com/shoes/shoes4/issues/641
  def width
    @stack.width
  end

  def width=(value)
    @stack.width = value
  end

  def initialize(color, args)
    @@boxes << self
    @stack = stack(args) do
      background color
      para link("Box #{@@boxes.length}", fg: white, fill: nil, click: "/"),
           margin: 18, align: "center", size: 20
      hover { expand }
    end
  end

  def expand
    if self.width < 170
      a = animate 30 do
        @@boxes.each do |b|
          b.width -= 5 if (b != self) && b.width > 140
        end
        self.width += 5
        a.stop if self.width >= 170
      end
    end
  end
end

Shoes.app width: 600, height: 130 do
  style(Shoes::Link, underline: nil)

  # hover styling currently a no-op https://github.com/shoes/shoes4/issues/638
  style(Shoes::LinkHover, fill: nil, underline: nil)

  menu_panel green,  width: 170, height: 120, margin: 4
  menu_panel blue,   width: 140, height: 120, margin: 4
  menu_panel red,    width: 140, height: 120, margin: 4
  menu_panel purple, width: 140, height: 120, margin: 4
end
