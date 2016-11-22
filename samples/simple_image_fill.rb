Shoes.app do
  blue_box = File.expand_path(File.join(__FILE__, '../blue-box.png'))

  rect 50, 50, 150, 150, strokewidth: 5, fill: pattern(blue_box)
  rect 70, 70, 150, 150, strokewidth: 5, fill: pattern(blue_box)

  oval 300, 50, 200, 200, strokewidth: 5, fill: pattern(blue_box)
  oval 320, 70, 200, 200, strokewidth: 5, fill: pattern(blue_box)

  star 120, 250, 17, 100, 50, strokewidth: 5, fill: pattern(blue_box)
  star 160, 290, 17, 100, 50, strokewidth: 5, fill: pattern(blue_box)
end
