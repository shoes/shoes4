Shoes.app do
  a=radio
  para "radio button1"
  radio
  para "radio button2"
  button "show button 1 status" do
    puts a.checked?
  end
  button "uncheck" do
    a.checked = false
  end
  puts "radio status: #{a.class}"
end
