Shoes.app width: 400, height: 300 do
  stack margin: 20 do
    @dimensions = title "width: #{width}, height: #{height} (default)"
    para "Resize the window and click 'report' to show new dimensions"
    button 'report' do
      @dimensions.replace "width: #{width}, height: #{height}"
    end
  end
end
