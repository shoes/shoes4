module WhiteShoes
  module Sound
    def gui_sound_init
      # no-op
    end
  end
end

module Shoes
  class Sound
    include WhiteShoes::Sound
  end
end
