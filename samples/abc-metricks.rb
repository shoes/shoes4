Shoes.app :width => 600, margin: 10 do
  para "Original width: 600"
  para "All margin: 10"
  para "Borders strokewidth: 5, curve: 20"
  border black, strokewidth: 5, curve: 20
  button "app flow1 black border" do
    alert(style.inspect)
  end
  button "app flow2black border" do
    alert(style.inspect)
  end
  button "app flow3black border" do
    alert(style.inspect)
  end
  stack margin: 10 do
    border red, strokewidth: 5, curve: 20
    button "first stack red border" do
      alert(style.inspect)
    end
    check
    stack margin:10 do
      border green, strokewidth: 5, curve: 20
      button "second stack green border"
      flow margin: 10 do
        border blue, strokewidth: 5, curve: 20
        button "first flow blue border"
        radio
        check
        check
        check
        para "Hello"
        check
        button "button w"
        button "button x"
        button "button y"
        button "last first flow"
      end
      check
      button "button a"
      flow margin: 10 do

      end
      button "button b"
      flow margin: 10 do
        border yellow, strokewidth: 5, curve: 20
        button "second flow yellow border"
        radio
        radio
        check
        check
        button "button 2"
        button "button 3"
        button "button 4"
        button "last second flow"
      end
      button "second stack last"
    end
    button "first stack last"
  end
  button "app last"
end