#
# Smiling face by Coraline Clark (age 5), 2013
#
Shoes.app do
  stack :top => 150 do
    @oval = oval  200, 1, 200, 200, :fill => mintcream
    @hair = star 200,  1, 80,  80
    @eye1 = star 300, 58, 10,  10, 6
    @eye2 = star 330, 58, 10,  10, 6
    @mouth= oval 310, 120, 70, 40, :fill => red
    @nose = line 310, 80, 340, 110
    @line = line 310, 140, 380, 140
  end
end
