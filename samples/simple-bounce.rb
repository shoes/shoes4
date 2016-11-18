xspeed = 8.4
yspeed = 6.6
xdir = 1
ydir = 1

Shoes.app do
  background "#DFA"
  border black, strokewidth: 6

  nostroke
  @icon = image "#{Shoes::DIR}/static/shoes-icon.png", left: 100, top: 100 do
    alert "You're soooo quick."
  end

  x = width / 2
  y = height / 2
  size = [@icon.height, @icon.width]
  animate(30) do
    x += xspeed * xdir
    y += yspeed * ydir

    xdir *= -1 if x > width - size[0] || x < 0
    ydir *= -1 if y > height - size[1] || y < 0

    @icon.move x.to_i, y.to_i
  end
end
