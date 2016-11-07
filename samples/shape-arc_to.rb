Shoes.app do
  shape do
    move_to(90, 55)
    arc_to(50, 55, 50, 20, 0, Shoes::PI / 2)
    arc_to(50, 55, 60, 60, Shoes::PI / 2, Shoes::PI)
    arc_to(50, 55, 70, 70, Shoes::PI, Shoes::TWO_PI - Shoes::PI / 2)
    arc_to(50, 55, 80, 80, Shoes::TWO_PI - Shoes::PI / 2, Shoes::TWO_PI)
  end
end
