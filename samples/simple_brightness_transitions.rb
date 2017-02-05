# frozen_string_literal: true
Shoes.app width: 300, height: 300 do
  10.times do |i|
    # light to dark
    flow(width: 0.5, height: 30) do
      background forestgreen(0.1 * (i + 1))
      para 'hello'
    end

    # dark to light
    flow(width: 0.5, height: 30) do
      background orangered(1.0 - 0.1 * i)
      para 'shoes'
    end
  end
end
