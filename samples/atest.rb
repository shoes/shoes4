Shoes.app margin: 10 do
  border black, strokewidth: 5, curve: 20
  button "app flow 1"
  button "app flow 2"
  button "app flow 3"
  stack margin: 10 do
    border red, strokewidth: 5, curve: 20
    button "stack 1"
    flow margin:10 do
      border yellow, strokewidth: 5, curve: 20
      button "flow 1"
      button "flow 2"
      button "flow 3"
    end
    button "stack 2"
    button "stack 3"
  end
end