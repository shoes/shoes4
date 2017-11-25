# frozen_string_literal: true

class Vader < SimpleDelegator
  def initialize(app)
    super(app)

    arc 50, 50, 100, 100, Shoes::PI, 0
    oval 104, 80, 10, 6, fill: aliceblue
    oval 80, 80, 10, 6, fill: aliceblue
    line 80, 90, 80, 100, stroke: white
    line 90, 90, 90, 100, stroke: white
    line 100, 90, 100, 100, stroke: white
    line 110, 90, 110, 100, stroke: white
    rect 80, 100, 40, 20
    rect 25, 120, 150, 250
    line 45, 120, 35, 400, stroke: white
    line 145, 120, 160, 400, stroke: white

    rect 45, 370, 30, 40
    rect 125, 370, 30, 40
    @saber1 = line 60, 220, 60, 100, displace_left: 0, strokewidth: 10, stroke: darkred, cap: :curve
    @saber2 = line 60, 220, 60, 102, displace_left: 0, strokewidth: 5, stroke: red, cap: :curve
    @fist = oval 40, 220, 35, 30, fill: darkgray
  end

  def saber_right
    move_saber(10)
  end

  def saber_left
    move_saber(-10)
  end

  def move_saber(value)
    return if @animate_saber

    @animate_saber = animate do
      if (@saber1.left <= 30 && value.negative?) || (@saber1.left > 180 && value.positive?)
        @animate_saber.stop
        @animate_saber = nil
      else
        @saber1.left  += value
        @saber1.right += value

        @saber2.left  += value
        @saber2.right += value

        @fist.left += value
      end
    end
  end
end
