# frozen_string_literal: true

# a simple shoes app to show how to use the star.center_point method
Shoes.app width: 600, height: 600 do
  # Roy G. Biv!
  the_colors_of_the_rainbow = {
    red: Shoes::Color.new(255, 0, 0),
    orange: Shoes::Color.new(255, 127, 0),
    yellow: Shoes::Color.new(255, 255, 0),
    green: Shoes::Color.new(0, 255, 0),
    blue: Shoes::Color.new(0, 0, 255),
    indigo: Shoes::Color.new(75, 0, 130),
    violet: Shoes::Color.new(148, 0, 211)
  }

  # we will set some variables to describe the first band of our rainbow,
  # the red one.
  band_thickness = 10
  draw_left = 100
  draw_top = 200
  band_width = 400
  band_height = 400

  # tell Shoes how we're going to draw
  nofill
  strokewidth band_thickness

  # draw a band for each of the colors of the rainbow.
  the_colors_of_the_rainbow.each do |_color_name, color_rgb|
    stroke(color_rgb)
    arc draw_left, draw_top, band_width, band_height, Shoes::PI, 0

    # update variables for next run.  the left and top point increase because
    # we're drawing further in and down and the width decreases because we're
    # because each successive band has to be contained within the one prior.
    draw_left += band_thickness
    draw_top += band_thickness
    band_width -= (band_thickness * 2)
    band_height -= (band_thickness * 2)
  end

  # add to docs
  # 0 is 3 o'clock
  # unit of angle expected in arguments is RADIANS!  DAWG!
  # the arc has a left and top off set by the cumulative strokewidth of each band of the rainbow.
  # each successive band has a width and height that is 2x the cumulative strokewidth
  # shoes::PI, 0 remains the same.

  stroke(black)

  stack do
    @info = para ""
  end

  click do |*args|
    @info.text = args.inspect
  end
end
