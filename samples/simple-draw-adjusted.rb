Shoes.app do
  background "#999"
  stroke "#000"
  x, y = nil, nil
  motion do |_x, _y|
    if x and y and (x != _x or y != _y)
      line x, y, _x, _y
    end
    x, y = _x, _y
  end
end
