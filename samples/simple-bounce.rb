xspeed, yspeed = 8.4, 6.6
xdir, ydir = 1, 1

Shoes.app do
  background "#DFA"
  border black, :strokewidth => 6

  nostroke
  @icon = image "#{DIR}/static/shoes-icon.png", :left => 100, :top => 100 do
    alert "You're soooo quick."
  end

  x, y = self.width / 2, self.height / 2
  size = @icon.size
  animate(30) do
    x += xspeed * xdir
    y += yspeed * ydir
    
    xdir *= -1 if x > self.width - size[0] or x < 0
    ydir *= -1 if y > self.height - size[1] or y < 0

    @icon.move x.to_i, y.to_i
  end
end
