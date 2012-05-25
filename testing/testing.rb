Shoes.app do
  flow :margin => 30 do
  @b1 = button "Click Me" do
    #debugger
    @b2.displace(0, 20)
    puts "I've been clicked!'"
  end
  @b2 = button "Click Me2" do
    puts "I've been clicked2!'"
  end
  @b3 = button "Click Me3" do
    puts "I've been clicked3!'"
  end
  end
  
end
