module WhiteShoes
  module Animation
    def gui_init
      # Simulate an animation thread (note: this never stops)
      Thread.new do
        loop do
          @blk.call(@current_frame)
          @current_frame += 1
          sleep(1/@framerate)
        end
      end.run
    end
  end
end

module Shoes
  class Animation
    include WhiteShoes::Animation
  end
end
