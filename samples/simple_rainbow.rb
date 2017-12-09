# frozen_string_literal: true

# a simple shoes app to draw a rainbow and explain a little about how arcs work along
# the way.
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

  # tell Shoes *how* we're going to draw it.
  nofill
  strokewidth band_thickness

  # now draw a band for each of the colors of the rainbow!
  the_colors_of_the_rainbow.each_value do |color_rgb|
    stroke(color_rgb)

    # The starting point for drawing an arc is at 3 o'clock.  We want to start our
    # rainbow 180 degrees from there (9 o'clock) and draw back to the 3 o'clock position.
    # nb: arcs in shoes measure angels in radians!
    arc draw_left, draw_top, band_width, band_height, Shoes::PI, 0

    # update variables for next run.  the left and top point increase because
    # we're drawing further in and down and the width decreases because each
    # successive band has to be contained within the one prior.
    draw_left += band_thickness
    draw_top += band_thickness
    band_width -= (band_thickness * 2)
    band_height -= (band_thickness * 2)
  end

  # an info block that updates with the cordinates of the mouse when clicked.
  # (so you can see where your arcs are being drawn!)
  stroke(black)

  stack do
    @info = para ""
  end

  click do |*args|
    @info.text = args.inspect
  end
end
