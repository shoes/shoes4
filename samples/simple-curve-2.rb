Shoes.app do
  x, y = 25.6, 128.0
  x1 = 102.4; y1 = 230.4
  x2 = 153.6; y2 = 25.6
  x3 = 230.4; y3 = 128.0

  nofill
  strokewidth 10.0

  curve x, y, x1, y1, x2, y2, x3, y3

  strokewidth 6.0
  stroke rgb(1.0, 0.2, 0.2, 0.6)
  
  line x, y, x1, y1
  line x2, y2, x3, y3
end
