Shoes.app width: 400, height: 400 do
  vx, vy = 3, 4

  @ball = oval 0, 0, 20, 20, fill: forestgreen, stroke: nil
  @comp = rect 0, 0, 75, 4, curve: 3
  @you = rect 0, 396, 75, 4, curve: 3

  @anim = animate 32 do
    nx, ny = @ball.left + vx.to_i, @ball.top + vy.to_i

    if @ball.top + 20 < 0 or @ball.top > 400
      t = title 'GAME OVER', align: 'center'
      p = para @ball.top < 0 ? "You win!" : "Computer wins", align: 'center'
      @anim.remove
      app.gui.real.getLayout.layout
      t.move 0, 150
      p.move 0, 200
    end

    vx = -vx  if nx + 20 > 400 or nx < 0

    if ny + 20 > 400 and nx + 20 > @you.left and nx < @you.left + 75
      vy = -vy * 1.2
      vx = (nx - @you.left - (75 / 2)) * 0.25
    end

    if ny < 0 and nx + 20 > @comp.left and nx < @comp.left + 75
      vy = -vy * 1.2
      vx = (nx - @comp.left - (75 / 2)) * 0.25
    end

    @ball.move nx, ny
    @you.move mouse[1] - (75 / 2), @you.top
    @comp.move(@comp.left + 10, @comp.top)  if @comp.left + 75 < @ball.left
    @comp.move(@comp.left - 10, @comp.top)  if @ball.left + 20 < @comp.left
  end
end
