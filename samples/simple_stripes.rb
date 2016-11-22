Shoes.app do
  spacing = 20

  50.times do |i|
    line(0, spacing * i, 1000, 1000 + (spacing * i))
    line(spacing * (i + 1), 0, 1000 + (spacing * (i + 1)), 1000)
  end
end
