Shoes.app do
  flow margin: 12 do
    # Set up three buttons
    button "One"
    @two = button "Two"
    button "Three"

    # Bounce the second button
    animate do |i|
      @two.move(40, 40 + (Math.sin(i) * 6).to_i)
    end
  end
end