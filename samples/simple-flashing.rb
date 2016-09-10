Shoes.app width: 300, height: 300 do
  COLORS = Shoes::COLORS
  background cadetblue
  r = rect 100, 10, 100, 100, fill: red, strokewidth: 5, curve: 10, stroke: pink do
    alert 'Yay!'
  end
  o = oval 100, 110, 100, fill: green, strokewidth: 10, stroke: white
  para 'Shoes 4!!!!!!', left: 100, top: 70

  size = COLORS.keys.size
  j = 0
  a = animate 1 do |i|
    unless j == i
      r.style fill: send(COLORS.keys[rand size]), stroke: send(COLORS.keys[rand size])
      o.style fill: send(COLORS.keys[rand size]), stroke: send(COLORS.keys[rand size])
      j = i
    end
  end

  button('pause') {a.toggle}
end
