# frozen_string_literal: true
Shoes.app do
  para "The following art elements would have shown in the top corner if not for translate!", center: true, size: 20

  translate 100, 100
  rect 0, 0, 100, 100, fill: blue

  translate 200, 200
  oval 0, 0, 100, 100, fill: green
end
