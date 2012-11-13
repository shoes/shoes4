Shoes.app do
   @slot = stack { para "Old text" }
   a = animate do |i|
     if i > 20
        @slot.clear { para "Brand new text" }
        a.stop
     end
   end
 end