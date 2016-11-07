#
# a translation from a processing example
# http://vormplus.be/weging/an-introduction-to-processing/
#
Shoes.app width: 420, height: 420, resizable: false do
  stage = 0
  wide = 3
  sw = 1.0
  basesize = 600
  step = 60
  stroke white(100)
  nofill

  animate 40 do |i|
    stage = rand(1...8) if i % 40 == 0
    if wide.abs < 0.1
      wide = if stage == 6
               -0.1
             else
               0.1
             end
    end
    rotation = -(Shoes::HALF_PI / wide)
    clear do
      background gray(240)
      10.times do |j|
        strokewidth sw * j
        size = (basesize + step * j) / 3
        top = (height - size) / 2
        left = (width - size) / 2
        arc top, left,
            size, size,
            rotation * j,
            rotation * j + Shoes::TWO_PI - Shoes::HALF_PI
      end
    end

    case stage
    when 1 then wide -= 0.1
    when 2 then wide += 0.1
    when 3 then basesize -= 1
    when 4 then basesize += 2
    when 5 then sw += 0.1
    when 6 then sw = [sw - 0.1, 0.1].max
    when 7 then step += 2
    else
      step -= 1
    end
  end
end
