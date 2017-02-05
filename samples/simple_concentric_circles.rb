# frozen_string_literal: true
Shoes.app width: 330, height: 300 do
  nofill
  rect 100, 20, 130, 251, stroke: red, fill: yellow
  18.times do |i|
    rotate 10 * i
    rect 100, 20, 130, 251
  end
end
