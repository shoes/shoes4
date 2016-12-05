Shoes.app do
  # Shoes 3 doesn't support button.text
  position_report = ->(button, button_text) { @position_report.replace "#{button_text}: (#{button.left}, #{button.top})" }
  flow margin: 12 do
    # Set up three buttons
    button "One", click: proc { |button| position_report.call(button, "One") }
    @two = button "Two", click: proc { |button| position_report.call(button, "Two") }
    button "Three", click: proc { |button| position_report.call(button, "Three") }
    @position_report = para ''
    # Bounce the second button
    animate do |i|
      @two.displace(0, (Math.sin(i) * 6).to_i)
    end
  end
end
