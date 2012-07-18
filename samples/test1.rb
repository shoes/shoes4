Shoes.app do
  flow width: 1.0 do
    30.times{|i| button "Button#{i}"}
  end
  3.times do
    stack(width: 200){3.times{button 'BUTTON'}}
  end
end
