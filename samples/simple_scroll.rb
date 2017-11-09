# frozen_string_literal: true

Shoes.app height: 150 do
  @stack = stack height: 150, scroll: true do
    para strong("Press arrow keys to scroll too!\n")
    20.times do |i|
      para i.to_s
    end

    oval 50, 50, 50, 50, fill: orange
    rect 50, 150, 50, 50, fill: purple
    arrow 80, 250, 60, fill: green
  end

  keypress do |key|
    if key == :up
      @stack.scroll_top -= 10
    else
      @stack.scroll_top += 10
    end
  end
end
