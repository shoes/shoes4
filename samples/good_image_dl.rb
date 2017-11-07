# frozen_string_literal: true

Shoes.app width: 300, height: 200 do
  background lime..blue

  stack do
    para "Welcome to the world of Shoes!"
    button "Click me" do
      alert "Nice click!"
    end
    image "http://shoesrb.com/img/shoes-icon.png",
          margin_top: 20, margin_left: 10
  end
end
