# simple-chipmunk.rb
require 'shoes/chipmunk'

Shoes.app title: 'A Tiny Chipmunk Physics Demo' do
  extend ChipMunk
  space = cp_space
  balls = []
  
  nofill
  cp_line 0, 180, 200, 280, stroke: gold
  cp_line 200, 280, 300, 270, stroke: gold
  cp_line 250, 350, 350, 330
  cp_line 170, 370, 220, 380
  cp_line 100, 450, 300, 430, stroke: lightslategray
  cp_line 300, 430, 500, 450, stroke: lightslategray

  nostroke
  oval(10, 30, 40, fill: blue).click{balls << cp_oval(30, 50, 20, stroke: blue, strokewidth: 2)}
  oval(70, 40, 20, fill: green).click{balls << cp_oval(80, 50, 10, fill: green)}
  oval(105, 45, 10, fill: red).click{balls << cp_oval(110, 50, 5, fill: red)}
  
  every do
    6.times{space.step 1.0/60}
    balls.each{|ball| ball.cp_move}
  end
end
