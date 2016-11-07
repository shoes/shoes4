Shoes.app do
  background "#999"
  stroke "#000"
  x = nil
  y = nil
  motion do |x2, y2|
    if x && y && ((x != x2) || (y != y2))
      append do
        line x, y, x2, y2
      end
    end
    x = x2
    y = y2
  end
end
