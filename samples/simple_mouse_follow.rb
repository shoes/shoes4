# frozen_string_literal: true

Shoes.app width: 200, height: 200 do
  background black
  fill white
  @circ = oval 0, 0, 100
  motion do |top, left|
    @circ.move top - 50, left - 50
  end
end
