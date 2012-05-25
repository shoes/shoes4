#
# Pong in Shoes
# a clone of http://billmill.org/pong.html
# and shoes is at http://shoooes.net
#
# This is just for kicks -- I'm very fond of NodeBox as well.
#
# There's a slightly different approach in Shoes: rather than
# redrawing the shapes, you can move the shapes around as objects.
# Yeah, see, notice how @you, @comp and @ball are used.
#
Shoes.app :width => 400, :height => 400, :resizable => false do
  paddle_size = 75
  ball_diameter = 20
  vx, vy = [3, 4]
  compuspeed = 10
  bounce = 1.2

  # set up the playing board
  nostroke and background white
  @ball = oval 0, 0, ball_diameter, :fill => "#9B7"
  @you, @comp = [app.height-4, 0].map {|y| rect 0, y, paddle_size, 4, :curve => 2}

  # animates at 40 frames per second
  @anim = animate 40 do

    # check for game over
    if @ball.top + ball_diameter < 0 or @ball.top > app.height
      para strong("GAME OVER", :size => 32), "\n",
        @ball.top < 0 ? "You win!" : "Computer wins", :top => 140, :align => 'center'
      @ball.hide and @anim.stop
    end

    # move the @you paddle, following the mouse
    @you.left = mouse[1] - (paddle_size / 2)
    nx, ny = (@ball.left + vx).to_i, (@ball.top + vy).to_i

    # move the @comp paddle, speed based on `compuspeed` variable
    @comp.left += 
      if nx + (ball_diameter / 2) > @comp.left + paddle_size;  compuspeed
      elsif nx < @comp.left;                                  -compuspeed
      else 0 end

    # if the @you paddle hits the ball
    if ny + ball_diameter > app.height and vy > 0 and
        (0..paddle_size).include? nx + (ball_diameter / 2) - @you.left
      vx, vy = (nx - @you.left - (paddle_size / 2)) * 0.25, -vy * bounce
      ny = app.height - ball_diameter
    end

    # if the @comp paddle hits the ball
    if ny < 0 and vy < 0 and
        (0..paddle_size).include? nx + (ball_diameter / 2) - @comp.left
      vx, vy = (nx - @comp.left - (paddle_size / 2)) * 0.25, -vy * bounce
      ny = 0
    elsif nx + ball_diameter > app.width or nx < 0
      vx = -vx
    end

    @ball.move nx, ny
  end
end
