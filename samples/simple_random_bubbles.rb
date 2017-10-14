# frozen_string_literal: true

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
    oval left: rand(-30..width), top: rand(-30..height), diameter: rand(25..100)
  end
end
