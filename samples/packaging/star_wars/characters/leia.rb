# frozen_string_literal: true

class Leia < SimpleDelegator
  def initialize(app)
    super(app)

    oval 550, 100, 70, 80, fill: antiquewhite
    oval 530, 120, 30, 40, fill: saddlebrown
    oval 610, 120, 30, 40, fill: chocolate

    oval 570, 130, 6, 3, fill: blue, stroke: blue
    oval 590, 130, 6, 3, fill: blue, stroke: blue
    para "^", left: 575, top: 135

    line 562, 170, 540, 400
    line 602, 171, 658, 400
    line 540, 400, 658, 400

    @leia_saber1 = line 495, 235, 495, 235, displace_left: 0, strokewidth: 10, stroke: fuchsia, cap: :curve
    @leia_saber2 = line 495, 245, 495, 245, displace_left: 0, strokewidth: 5, stroke: darkmagenta, cap: :curve

    line 494, 232, 561, 184
    line 494, 232, 555, 235
    oval 484, 230, 20, 20, fill: peachpuff

    line 605, 182, 691, 218
    line 620, 235, 690, 226
    oval 688, 212, 20, 20, fill: bisque

    rect 560, 400, 20, 30
    rect 620, 400, 20, 30
  end

  def open_saber
    move_leia_saber(20)
  end

  def close_saber
    move_leia_saber(-20)
  end

  def move_leia_saber(value)
    return if @animate_leia

    @animate_leia = animate do
      if (@leia_saber1.height > 150 && value.positive?) || (@leia_saber1.height < 1 && value.negative?)
        @animate_leia.stop
        @animate_leia = nil
      else
        @leia_saber1.top -= value
        @leia_saber1.height += value

        @leia_saber2.top -= value
        @leia_saber2.height += value
      end
    end
  end
end
