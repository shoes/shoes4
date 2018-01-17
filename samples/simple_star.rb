# frozen_string_literal: true

# a simple shoes app to show how to use the star.center_point method
Shoes.app width: 600, height: 600 do
  fill rgb(158, 223, 229, 0.1)
  stroke rgb(0, 0.6, 0.9)
  strokewidth 0.25
  @pleione = star 200, 100

  # draw two lines that intersect the center of the star
  center_point = @pleione.center_point
  line center_point.x, 0, center_point.x, 500
  line 0, center_point.y, 500, center_point.y

  # draw a small circle at the center of the star
  radius = 3
  oval (center_point.x - radius), (center_point.y - radius), radius: radius

  # do you want a well centered star to follow you around?
  @churyumov_gerasimenko = star 200, 100, center: true
  motion do |x, y|
    @churyumov_gerasimenko.center_point = Shoes::Point.new(x, y)
  end

  # an info block to show the coordinates of a click and the center_point
  # of @churyumov_gerasimenko.
  stroke(black)

  stack do
    @info = para ""
    @info2 = para ""
  end

  click do |*args|
    @info.text = args.inspect
    @info2.text = @churyumov_gerasimenko.center_point.inspect
  end
end
