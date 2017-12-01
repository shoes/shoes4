# frozen_string_literal: true

# Tankspank
# kevin conner
# connerk@gmail.com
# version 3, 13 March 2008
# this code is free, do what you like with it!

WIDTH = 700
HEIGHT = 500
CAMERA_TIGHTNESS = 0.1

module Collisions
  def contains?(x, y)
    !(x < west || x > east || y < north || y > south)
  end

  def intersects?(other)
    !(other.east < west || other.west > east ||
      other.south < north || other.north > south)
  end
end

class Building
  include Collisions

  attr_reader :west, :east, :north, :south

  def initialize(west, east, north, south)
    @west = west
    @east = east
    @north = north
    @south = south
    @top = 1.1 + rand(3) * 0.15
    @bottom = 1.0

    color = (1..3).collect { 0.2 + 0.4 * rand }
    color << 0.9
    @stroke = Opp.app.rgb(*color)
    color[-1] = 0.3
    @fill = Opp.app.rgb(*color)
  end

  def draw
    Opp.app.stroke @stroke
    Opp.app.fill @fill
    Opp.draw_opp_box(@west, @east, @north, @south, @top, @bottom)
  end
end

module Guidance
  def guidance_system(x, y, dest_x, dest_y, angle)
    vx = dest_x - x
    vy = dest_y - y
    if vx.abs < 0.1 && (vy.abs <= 0.1)
      yield 0, 0
    else
      length = Math.sqrt(vx * vx + vy * vy)
      vx /= length
      vy /= length
      ax = Math.cos(angle)
      ay = Math.sin(angle)
      cos_between = vx * ax + vy * ay
      sin_between = vx * -ay + vy * ax
      yield sin_between, cos_between
    end
  end
end

module Life
  attr_reader :health
  def dead?
    @health.zero?
  end

  def hurt(damage)
    @health = [@health - damage, 0].max
  end
end

class Tank
  include Collisions
  include Guidance
  include Life
  # ^ sounds like insurance

  COLLIDE_SIZE = 15

  def west
    @x - COLLIDE_SIZE
  end

  def east
    @x + COLLIDE_SIZE
  end

  def north
    @y - COLLIDE_SIZE
  end

  def south
    @y + COLLIDE_SIZE
  end

  attr_reader :x, :y

  def initialize
    @x = 0
    @y = -125
    @last_x = @x
    @last_y = @y
    @tank_angle = 0.0
    @dest_x = 0
    @dest_y = 0
    @acceleration = 0.0
    @speed = 0.0
    @moving = false

    @aim_angle = 0.0
    @target_x = 0
    @target_y = 0
    @aimed = false

    @health = 100
  end

  def set_destination
    @dest_x = @target_x
    @dest_y = @target_y
    @moving = true
  end

  def fire
    Opp.add_shell Shell.new(@x + 30 * Math.cos(@aim_angle),
                            @y + 30 * Math.sin(@aim_angle), @aim_angle)
  end

  def update(_button, mouse_x, mouse_y)
    @target_x = mouse_x
    @target_y = mouse_y

    if @moving
      guidance_system @x, @y, @dest_x, @dest_y, @tank_angle do |direction, on_target|
        turn direction
        @acceleration = on_target * 0.25
      end

      distance = Math.sqrt((@dest_x - @x)**2 + (@dest_y - @y)**2)
      @moving = false if distance < 50
    else
      @acceleration = 0.0
    end

    guidance_system @x, @y, @target_x, @target_y, @aim_angle do |direction, on_target|
      aim direction
      @aimed = on_target > 0.98
    end

    integrity = @health / 100.0 # the more hurt you are, the slower you go
    @speed = [[@speed + @acceleration, 5.0 * integrity].min, -3.0 * integrity].max
    @speed *= 0.9 unless @moving

    @last_x = @x
    @last_y = @y
    @x += @speed * Math.cos(@tank_angle)
    @y += @speed * Math.sin(@tank_angle)
  end

  def collide_and_stop
    @x = @last_x
    @y = @last_y
    hurt @speed.abs * 3 + 5
    @speed = 0
    @moving = false
  end

  def turn(direction)
    @tank_angle += [[-0.03, direction].max, 0.03].min
  end

  def aim(direction)
    @aim_angle += [[-0.1, direction].max, 0.1].min
  end

  def draw
    Opp.app.stroke Opp.app.blue
    Opp.app.fill Opp.app.blue(0.4)
    Opp.draw_opp_rect @x - 20, @x + 20, @y - 15, @y + 15, 1.05, @tank_angle
    # Opp.draw_opp_box @x - 20, @x + 20, @y - 20, @y + 20, 1.03, 1.0
    Opp.draw_opp_rect @x - 10, @x + 10, @y - 7, @y + 7, 1.05, @aim_angle
    x, _unused1, y, _unused2 = Opp.project(@x, 0, @y, 0, 1.05)
    Opp.app.line x, y, x + 25 * Math.cos(@aim_angle), y + 25 * Math.sin(@aim_angle)

    Opp.app.stroke Opp.app.red
    Opp.app.fill Opp.app.red(@aimed ? 0.4 : 0.1)
    Opp.draw_opp_oval @target_x - 10, @target_x + 10, @target_y - 10, @target_y + 10, 1.00

    return unless @moving

    Opp.app.stroke Opp.app.green
    Opp.app.fill Opp.app.green(0.2)
    Opp.draw_opp_oval @dest_x - 20, @dest_x + 20, @dest_y - 20, @dest_y + 20, 1.00
  end
end

class Shell
  attr_reader :x, :y

  def initialize(x, y, angle)
    @x = x
    @y = y
    @angle = angle
    @speed = 10.0
  end

  def update
    @x += @speed * Math.cos(@angle)
    @y += @speed * Math.sin(@angle)
  end

  def draw
    Opp.app.stroke Opp.app.red
    Opp.app.fill Opp.app.red(0.1)
    Opp.draw_opp_box @x - 2, @x + 2, @y - 2, @y + 2, 1.05, 1.04
  end
end

class Opp
  def self.app
    @app
  end

  def self.app=(app)
    @app = app
  end

  def self.new_game
    @offset_x = 0
    @offset_y = 0
    @buildings = [
      [-1000, -750, -750, -250],
      [-500, 250, -750, -250],
      [500, 1000, -750, -500],
      [750, 1250, -250, 0],
      [750, 1250, 250, 750],
      [250, 500, 0, 750],
      [-250, 0, 0, 500],
      [-500, 0, 750, 1000],
      [-1000, -500, 0, 500],
      [400, 600, -350, -150]
    ].collect { |p| Building.new(*p) }
    @shells = []
    @boundary = [-1250, 1500, -1250, 1250]
    @tank = Tank.new
    @center_x = Opp.app.width / 2
    @center_y = Opp.app.height / 2
  end

  def self.tank
    @tank
  end

  def self.read_input
    @input = Opp.app.mouse
  end

  def self.update_scene
    button, x, y = @input
    x += @offset_x - @center_x
    y += @offset_y - @center_y

    @tank.update(button, x, y) unless @tank.dead?
    @buildings.each do |b|
      @tank.collide_and_stop if b.intersects? @tank
    end

    @shells.each(&:update)
    @buildings.each do |b|
      @shells.reject! do |s|
        b.contains?(s.x, s.y)
      end
    end
    # collide shells with tanks -- don't need this until there are enemy tanks
    # @shells.reject! do |s|
    # @tank.contains?(s.x, s.y)
    # end

    Opp.app.clear do
      @offset_x += CAMERA_TIGHTNESS * (@tank.x - @offset_x)
      @offset_y += CAMERA_TIGHTNESS * (@tank.y - @offset_y)

      Opp.app.background Opp.app.black
      @center_x = Opp.app.width / 2
      @center_y = Opp.app.height / 2

      Opp.app.stroke Opp.app.red(0.9)
      Opp.app.nofill
      draw_opp_box(*(@boundary + [1.1, 1.0, false]))

      @tank.draw
      @shells.each(&:draw)
      @buildings.each(&:draw)
    end
  end

  def self.add_shell(shell)
    @shells << shell
    @shells.shift if @shells.size > 10
  end

  def self.project(left, right, top, bottom, depth)
    [left, right].collect { |x| @center_x + depth * (x - @offset_x) } +
      [top, bottom].collect { |y| @center_y + depth * (y - @offset_y) }
  end

  # here "front" and "back" push the rect into and out of the window.
  # 1.0 means your x and y units are pixels on the surface.
  # greater than that brings the box closer.  less pushes it back.  0.0 => infinity.
  # the front will be filled but the rest is wireframe only.
  def self.draw_opp_box(left, right, top, bottom, front, back, occlude = true)
    near_left, near_right, near_top, near_bottom = project(left, right, top, bottom, front)
    far_left, far_right, far_top, far_bottom = project(left, right, top, bottom, back)

    # determine which sides of the box are visible
    if occlude
      draw_left = @center_x < near_left
      draw_right = near_right < @center_x
      draw_top = @center_y < near_top
      draw_bottom = near_bottom < @center_y
    else
      draw_left, draw_right, draw_top, draw_bottom = [true] * 4
    end

    # draw lines for the back edges
    Opp.app.line far_left, far_top, far_right, far_top if draw_top
    Opp.app.line far_left, far_bottom, far_right, far_bottom if draw_bottom
    Opp.app.line far_left, far_top, far_left, far_bottom if draw_left
    Opp.app.line far_right, far_top, far_right, far_bottom if draw_right

    # draw lines to connect the front and back
    Opp.app.line near_left, near_top, far_left, far_top if draw_left || draw_top
    Opp.app.line near_right, near_top, far_right, far_top if draw_right || draw_top
    Opp.app.line near_left, near_bottom, far_left, far_bottom if draw_left || draw_bottom
    Opp.app.line near_right, near_bottom, far_right, far_bottom if draw_right || draw_bottom

    # draw the front, filled
    Opp.app.rect near_left, near_top, near_right - near_left, near_bottom - near_top
  end

  def self.draw_opp_rect(left, right, top, bottom, depth, angle, _with_x = false)
    pl, pr, pt, pb = project(left, right, top, bottom, depth)
    cos = Math.cos(angle)
    sin = Math.sin(angle)
    cx = (pr + pl) / 2.0
    cy = (pb + pt) / 2.0
    points = [[pl, pt], [pr, pt], [pr, pb], [pl, pb]].collect do |x, y|
      [cx + (x - cx) * cos - (y - cy) * sin,
       cy + (x - cx) * sin + (y - cy) * cos]
    end

    Opp.app.line(*(points[0] + points[1]))
    Opp.app.line(*(points[1] + points[2]))
    Opp.app.line(*(points[2] + points[3]))
    Opp.app.line(*(points[3] + points[0]))
  end

  def self.draw_opp_oval(left, right, top, bottom, depth)
    pl, pr, pt, pb = project(left, right, top, bottom, depth)
    Opp.app.oval(pl, pt, pr - pl, pb - pt)
  end

  def self.draw_opp_plane(x1, y1, x2, y2, front, back, stroke_color)
    near_x1, near_x2, near_y1, near_y2 = project(x1, x2, y1, y2, front)
    far_x1, far_x2, far_y1, far_y2 = project(x1, x2, y1, y2, back)

    Opp.app.stroke stroke_color

    Opp.app.line far_x1, far_y1, far_x2, far_y2
    Opp.app.line far_x1, far_y1, near_x1, near_y1
    Opp.app.line far_x2, far_y2, near_x2, near_y2
    Opp.app.line near_x1, near_y1, near_x2, near_y2
  end
end

Shoes.app width: WIDTH, height: HEIGHT do
  Opp.app = self

  Opp.new_game
  @playing = true

  keypress do |key|
    if @playing
      if (key == "1") || (key == "z")
        Opp.tank.set_destination
      elsif (key == "2") || (key == "x") || (key == " ")
        Opp.tank.fire
      end
    elsif key == "n"
      Opp.new_game
      @playing = true
    end
  end

  click do |button|
    if @playing
      if button == 1
        Opp.tank.set_destination
      else
        Opp.tank.fire
      end
    end
  end

  animate(60) do
    Opp.read_input if @playing
    Opp.update_scene

    @playing = false if Opp.tank.dead?
    unless @playing
      stack do
        banner "Game Over", stroke: white, margin: 10
        caption "learn to drive!", stroke: white, margin: 20
      end
    end
  end
end
