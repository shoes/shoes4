#
# Smiling face by Coraline Clark (age 5), 2013
#
Shoes.app do
  stack margin_top: 150, width: 1.0, height: 1.0 do
    @oval  = oval 200, 1, 200, 200, fill: mintcream
    @hair  = star 120, -80, 80, 80
    @eye1  = star 290, 48, 10,  10, 6
    @eye2  = star 320, 48, 10,  10, 6
    @mouth = oval 310, 120, 70, 40, fill: red
    @nose  = line 310, 80, 340, 110
    @line  = line 310, 140, 380, 140
  end
end
