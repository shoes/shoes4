degree = 0
color  = 0
size   = 0

Shoes.app width: 537, height: 500 do
  background rgb(1.0, 0.5, 1.0, 1.0)
  # Convert degrees to radians
  def to_radians(deg)
    deg * Math::PI / 180
  end

  red_circles, blue_circles = [], []

  mx, my = (500/2).to_i, (537/2).to_i
  animate(36) do
    #clear do
      # Manage color
      nostroke
      # Update some variables
      degree += 1
      size += 1
      degree = 0 if(degree >= 360)
      size = 0 if(size >= 100)
      color = 0.0 if(color >= 1.0)
      color += 0.05 if(degree % 10 == 0)

      # Draw inner circle
      fill red(color)
      10.times do |i|
        current_size = 100 + size
        d = to_radians(i * 60 + degree)
        rx = Math.cos(d) * 100
        ry = Math.sin(d) * 100
        center_x = -current_size/2 + rx + mx
        center_y = -current_size/2 + ry + my
        if red_circles.size == 10
          r = red_circles[i]
          r.style fill: red(color)
          r.left, r.top, r.width, r.height = center_x, center_y, current_size, current_size
        else
          red_circles << oval(center_x, center_y, current_size, current_size)
        end
      end

      # Draw outer circle
      fill blue(color)
      20.times do |i|
        current_size = 50 + size
        d = to_radians(i * 30 - degree)
        rx = Math.cos(d) * 150
        ry = Math.sin(d) * 150
        center_x = -current_size/2 + rx + mx
        center_y = -current_size/2 + ry + my
        if blue_circles.size == 20
          b = blue_circles[i]
          b.style fill: blue(color)
          b.left, b.top, b.width, b.height = center_x, center_y, current_size, current_size
        else
          blue_circles << oval(center_x, center_y, current_size, current_size)
        end
      end
    #end
  end
end
