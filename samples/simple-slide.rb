#
# mimicking the mootools demo for Fx.Slide
# http://demos.mootools.net/Fx.Slide
#
Shoes.app do
  def stop_anim
    @anim.stop
    @anim = nil
  end
  def slide_anim &blk
    stop_anim if @anim
    @anim = animate 30, &blk
  end
  def slide_out slot
    slide_anim do |i|
      slot.height = 150 - (i * 3)
      slot.contents[0].top = -i * 3
      if slot.height == 0
        stop_anim
        slot.hide
      end
    end
  end
  def slide_in slot
    slot.show
    slide_anim do |i|
      slot.height = i * 6
      slot.contents[0].top = slot.height - 150
      stop_anim if slot.height == 150
    end
  end

  background white
  stack :margin => 10 do
    para link("slide out") { slide_out @lipsum }, " | ",
      link("slide in") { slide_in @lipsum }
    @lipsum = stack :width => 1.0, :height => 150 do
      stack do
        background "#ddd"
        border "#eee", :strokewidth => 5
        para "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", :margin => 10
      end
    end
  end
end
