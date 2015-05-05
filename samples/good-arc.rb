#
# a translation from a processing example
# http://vormplus.be/weging/an-introduction-to-processing/
#
Shoes.app width: 420, height: 420, resizable: false do
  stage, wide, sw, basesize, step = 0, 3, 1.0, 600, 60
  stroke white(100)
  nofill

  animate 40 do |i|
    stage = rand(1...8) if i % 40 == 0
    if wide.abs < 0.1
      if stage == 6
        wide = -0.1
      else
        wide = 0.1
      end
    end
    rotation = -(Shoes::HALF_PI / wide)
    clear do
      background gray(240)
      10.times do |j|
        strokewidth sw * j
        size = (basesize + step * j) / 3
        top = (self.height - size) / 2
        left = (self.width - size) / 2
        arc top, left,
          size, size,
          rotation * j,
          rotation * j + Shoes::TWO_PI - Shoes::HALF_PI
      end
    end

    case stage
    when 1; wide -= 0.1
    when 2; wide += 0.1
    when 3; basesize -= 1
    when 4; basesize += 2
    when 5; sw += 0.1
    when 6; sw = [sw - 0.1, 0.1].max
    when 7; step += 2
    else    step -= 1
    end
  end
end
