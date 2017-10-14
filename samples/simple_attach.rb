# frozen_string_literal: true

Shoes.app do
  stack do
    background blue
    3.times do
      para "Three lines first!"
    end
  end

  stack attach: Shoes::Window, height: 30, width: 300 do
    background green
    para "Attached to the window!"
  end

  @next = stack margin: 20 do
    background yellow
    3.times do
      para "Three lines next!"
    end
  end

  stack attach: @next, height: 30, width: 300 do
    background red
    para "Sneaked up!"
  end
end
