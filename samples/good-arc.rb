#
# a translation from a processing example
# http://vormplus.be/weging/an-introduction-to-processing/
#
Shoes.app :width => 420, :height => 420, :resizable => false do
  stage, wide, sw, basesize, step = 0, 3.0, 1.0, 600, 60
  stroke gray(127)
  nofill

  animate 40 do |i|
    stage = (1...8).rand if i % 40 == 0
    rotation = -(HALF_PI / wide)
    clear do
      background gray(240)
      10.times do |i|
        strokewidth sw * i
        size = (basesize / 3) + ((step / 3) * i)
        shape do
          arc self.width / 2, self.height / 2,
              size, size,
              rotation * i, rotation * i + TWO_PI - HALF_PI
        end
      end
    end

    case stage
    when 1; wide -= 0.1
    when 2; wide += 0.1
    when 3; basesize -= 1
    when 4; basesize += 2
    when 5; sw += 0.1
    when 6; sw -= 0.01
    when 7; step += 2
    else    step -= 1
    end
  end
end
