#The Shoes logo/icon bounces on the screen. The logo/icon responds to menu options and if clicked on.
xspeed, yspeed = 10, 6
xdir, ydir = 1, 1

Shoes.app width: 300, height: 300 do
  a = nil
  button('toggle') {a.toggle}
  button('stop') {a.stop}
  button('start') {a.start}
  button('remove') {a.remove}
  img = image File.join(Shoes::DIR, 'static/shoes-icon.png') do
    alert "You're soooo quick!"
  end

  x, y = 150, 150
  size = [128, 128]
  pause = 0

  a = animate 24 do |n|
    unless pause == n
      x += xspeed * xdir
      y += yspeed * ydir

      xdir *= -1 if x > 300 - size[0] || x < 0
      ydir *= -1 if y > 300 - size[1] || y < 0

      img.move x.to_i, y.to_i
    end
    pause = n
  end
end
