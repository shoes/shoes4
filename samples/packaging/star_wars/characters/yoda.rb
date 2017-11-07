# frozen_string_literal: true

class Yoda < SimpleDelegator
  def initialize(app)
    super(app)

    @ears = []
    @ears << line(260, 150, 320, 235, strokewidth: 10, stroke: red)
    @ears << line(260, 150, 320, 220, strokewidth: 10, stroke: limegreen, cap: :curve)
    @ears << line(260, 150, 320, 250, strokewidth: 10, stroke: limegreen, cap: :curve)

    @ears << line(440, 150, 380, 235, strokewidth: 10, stroke: red)
    @ears << line(440, 150, 380, 220, strokewidth: 10, stroke: limegreen, cap: :curve)
    @ears << line(440, 150, 380, 250, strokewidth: 10, stroke: limegreen, cap: :curve)

    oval 300, 200, 100, 100, fill: limegreen, stroke: limegreen
    oval 320, 250, 10, 10
    oval 380, 250, 10, 10
    line 340, 220, 360, 220, stroke: aliceblue
    line 335, 230, 365, 230, stroke: aliceblue
    line 330, 240, 370, 240, stroke: aliceblue

    rect 300, 300, 100, 100, fill: brown, stroke: brown
    rect 340, 300, 20, 30, fill: black

    oval 290, 330, 20, 20, fill: limegreen, stroke: limegreen
    oval 400, 330, 20, 20, fill: limegreen, stroke: limegreen

    rect 310, 400, 20, 20, fill: limegreen, stroke: limegreen
    rect 370, 400, 20, 20, fill: limegreen, stroke: limegreen
  end

  def ears_down
    move_ears(10)
  end

  def ears_up
    move_ears(-10)
  end

  def move_ears(value)
    return if @animate_ears
    @animate_ears = animate do
      if (@ears.first.top > 220 && value.positive?) || (@ears.first.top <= 150 && value.negative?)
        @animate_ears.stop
        @animate_ears = nil
      else
        @ears.each do |ear|
          ear.top += value
        end
      end
    end
  end
end
