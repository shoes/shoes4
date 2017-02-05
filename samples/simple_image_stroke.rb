# frozen_string_literal: true
Shoes.app do
  red_box = File.expand_path(File.join(__FILE__, '../red-box.png'))

  rect 50, 50, 150, 150, strokewidth: 10, fill: gray, stroke: pattern(red_box)
  rect 120, 70, 150, 150, strokewidth: 10, fill: gray, stroke: pattern(red_box)

  oval 300, 50, 200, 200, strokewidth: 10, fill: gray, stroke: pattern(red_box)
  oval 350, 70, 200, 200, strokewidth: 10, fill: gray, stroke: pattern(red_box)

  star 120, 250, 17, 100, 50, strokewidth: 5, fill: gray, stroke: pattern(red_box)
  star 160, 290, 17, 100, 50, strokewidth: 5, fill: gray, stroke: pattern(red_box)
end
