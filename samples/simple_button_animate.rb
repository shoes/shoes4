# frozen_string_literal: true

Shoes.app do
  flow margin: 12 do
    # Set up three buttons
    button "Stop" do
      @anim.stop
    end
    @two = button "Watch Me!"
    button "Start" do
      @anim.start
    end
    # Bounce the second button
    @anim = animate do |frame|
      @two.displace(0, (Math.sin(frame) * 30).to_i)
    end
  end
end
