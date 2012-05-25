trails = [[0, 0]] * 60
Shoes.app :width => 200, :height => 200, :resizable => false do
  nostroke
  fill rgb(0x3, 0x1, 0x3, 0.6)

  # animation at 100 frames per second
  animate(60) do
    trails.shift
    trails << self.mouse[1, 2]

    clear do
      # change the background based on where the pointer is
      background rgb(
        20 + (70 * (trails.last[0].to_f / self.width)).to_i, 
        20 + (70 * (trails.last[1].to_f / self.height)).to_i,
        51)

      # draw circles progressively bigger
      trails.each_with_index do |(x, y), i|
        i += 1
        oval :left => x, :top => y, :radius => (i*0.5), :center => true
      end
    end
  end

end
