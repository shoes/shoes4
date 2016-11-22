Shoes.app do
  fill goldenrod
  stroke tomato
  strokewidth 6
  oval 200, 100, 360, 360
  animate 24 do |frame|
    left = 200 + Math.sin(frame) * 80
    top  = 100 + Math.cos(frame) * 80
    oval left, top, 360, 360
  end
end
