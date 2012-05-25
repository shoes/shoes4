Shoes.app do
  background rgb(0, 0, 0)
  fill rgb(255, 255, 255)
  rects = [
    rect(0, 0, 50, 50),
    rect(0, 0, 100, 100),
    rect(0, 0, 75, 75)
  ] 
  animate(24) do |i|
    rects.each do |r|
      r.move((0..400).rand, (0..400).rand)
    end
  end
  button "OK", :top => 0.5, :left => 0.5 do
    quit unless confirm "You ARE sure you're OK??"
  end
end
