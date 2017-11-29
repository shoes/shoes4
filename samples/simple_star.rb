# frozen_string_literal: true

# a simple shoes app to show how to use the star.center_point method
Shoes.app do
  fill rgb(0, 0.6, 0.9, 0.1)
  stroke rgb(0, 0.6, 0.9)
  strokewidth 0.25

  blurgh = star 200, 200

  center_point = blurgh.center_point

  line center_point.x, 0, center_point.x, 500
  line 0, center_point.y, 500, center_point.y

  radius = 3
  oval (center_point.x - radius), (center_point.y - radius), radius: radius
end
