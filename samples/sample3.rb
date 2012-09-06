class Range
  def rand
    Random.new.rand self
  end
end

Shoes.app width: 300, height: 400 do
  fill rgb(0, 0.6, 0.9, 0.1)
  stroke rgb(0, 0.6, 0.9, 0.3)
  strokewidth 1
  100.times do
    oval left: (-30..width).rand, top: (-30..height).rand, diameter: (25..100).rand
  end
end
