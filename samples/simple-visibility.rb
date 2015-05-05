Shoes.app do
  slot = stack do
    background lightsteelblue
    para 'Some content'
    button 'Hello' do alert 'hi there' end
  end

  button 'Show' do slot.show end
  button 'Hide' do slot.hide end
  button 'Toggle' do slot.toggle end
end
