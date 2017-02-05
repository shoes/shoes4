# frozen_string_literal: true
Shoes.app do
  stack top: 0.5, left: 0.5 do
    para "Counting up:"
    l = para "0"
    animate(24) do |i|
      f = ['Arial 14px', 'Serif 34px', 'Monospace 18px', 'Arial 48px'][rand(3)]
      l.replace i.to_s, font: f
    end
    motion do |x, y|
      Shoes.p [x, y]
    end
  end
end
