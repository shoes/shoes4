# frozen_string_literal: true
Shoes.app height: 200 do
  stack margin_left: 10 do
    title 'Progress Example'
    @p = para
  end

  pg = progress width: width - 20, height: 20
  pg.move 10, 100
  animate do |i|
    j = i % 100 + 1
    pg.fraction = j / 100.0
    @p.text = format("%2d%", (pg.fraction * 100))
  end
end
