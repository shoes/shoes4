Shoes.app do
  background black

  stack :top => 0.4, :left => 0.2 do
    @stripes = stack

    mask do
      title "Shoes", :weight => "bold", :size => 82
    end
  end
  
  animate 10 do
    @stripes.clear do
      20.times do |i|
        strokewidth 4
        stroke rgb((0.0..0.5).rand, (0.0..1.0).rand, (0.0..0.3).rand)
        line 0, i * 5, 400, i * 8
      end
    end
  end
end
