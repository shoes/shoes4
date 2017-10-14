# frozen_string_literal: true

#
# Shoes Clock by Thomas Bell
# posted to the Shoes mailing list on 04 Dec 2007
#
Shoes.app height: 260, width: 250 do
  @radius = 90
  @centerx = 126
  @centery = 140
  animate(8) do
    @time = Time.now
    clear do
      draw_background
      stack do
        background black
        para @time.strftime("%a"),
             span(@time.strftime(" %b %d, %Y "), stroke: "#ccc"),
             strong(@time.strftime("%I:%M"), stroke: white),
             @time.strftime(".%S"), align: "center", stroke: "#666",
                                    margin: 4
      end
      clock_hand @time.sec + (@time.usec * 0.000001), 2, 30, red
      clock_hand @time.min + (@time.sec / 60.0), 5
      clock_hand @time.hour + (@time.min / 60.0), 8, 6
    end
  end
  def draw_background
    background rgb(230, 240, 200)

    fill white
    stroke black
    strokewidth 4
    oval @centerx - 102, @centery - 102, 204, 204

    fill black
    nostroke
    oval @centerx - 5, @centery - 5, 10, 10

    stroke black
    strokewidth 1
    line(@centerx, @centery - 102, @centerx, @centery - 95)
    line(@centerx - 102, @centery, @centerx - 95, @centery)
    line(@centerx + 95, @centery, @centerx + 102, @centery)
    line(@centerx, @centery + 95, @centerx, @centery + 102)
  end

  def clock_hand(time, sw, unit = 30, color = black)
    radius_local = unit == 30 ? @radius : @radius - 15
    x = radius_local * Math.sin(time * Math::PI / unit)
    y = radius_local * Math.cos(time * Math::PI / unit)
    stroke color
    strokewidth sw
    line(@centerx, @centery, @centerx + x, @centery - y)
  end
end
