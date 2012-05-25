# Tankspank
# kevin conner
# connerk@gmail.com
# version 3, 13 March 2008
# this code is free, do what you like with it!

$width, $height = 700, 500
$camera_tightness = 0.1

module Collisions
	def contains? x, y
		not (x < west or x > east or y < north or y > south)
	end
	
	def intersects? other
		not (other.east < west or other.west > east or
			other.south < north or other.north > south)
	end
end

class Building
	include Collisions
	
	attr_reader :west, :east, :north, :south
	
	def initialize(west, east, north, south)
		@west, @east, @north, @south = west, east, north, south
		@top, @bottom = 1.1 + rand(3) * 0.15, 1.0
		
		color = (1..3).collect { 0.2 + 0.4 * rand }
		color << 0.9
		@stroke = $app.rgb *color
		color[-1] = 0.3
		@fill = $app.rgb *color
	end
	
	def draw
		$app.stroke @stroke
		$app.fill @fill
		Opp.draw_opp_box(@west, @east, @north, @south, @top, @bottom)
	end
end

module Guidance
	def guidance_system x, y, dest_x, dest_y, angle
		vx, vy = dest_x - x, dest_y - y
		if vx.abs < 0.1 and vy.abs <= 0.1
			yield 0, 0
		else
			length = Math.sqrt(vx * vx + vy * vy)
			vx /= length
			vy /= length
			ax, ay = Math.cos(angle), Math.sin(angle)
			cos_between = vx * ax + vy * ay
			sin_between = vx * -ay + vy * ax
			yield sin_between, cos_between
		end
	end
end

module Life
	attr_reader :health
	def dead?
		@health == 0
	end
	def hurt damage
		@health = [@health - damage, 0].max
	end
end

class Tank
	include Collisions
	include Guidance
	include Life
	# ^ sounds like insurance
	
	@@collide_size = 15
	def west; @x - @@collide_size; end
	def east; @x + @@collide_size; end
	def north; @y - @@collide_size; end
	def south; @y + @@collide_size; end
	
	attr_reader :x, :y
	
	def initialize
		@x, @y = 0, -125
		@last_x, @last_y = @x, @y
		@tank_angle = 0.0
		@dest_x, @dest_y = 0, 0
		@acceleration = 0.0
		@speed = 0.0
		@moving = false
		
		@aim_angle = 0.0
		@target_x, @target_y = 0, 0
		@aimed = false
		
		@health = 100
	end
	
	def set_destination
		@dest_x, @dest_y = @target_x, @target_y
		@moving = true
	end
	
	def fire
		Opp.add_shell Shell.new(@x + 30 * Math.cos(@aim_angle),
			@y + 30 * Math.sin(@aim_angle), @aim_angle)
	end
	
	def update button, mouse_x, mouse_y
		@target_x, @target_y = mouse_x, mouse_y
		
		if @moving
			guidance_system @x, @y, @dest_x, @dest_y, @tank_angle do |direction, on_target|
				turn direction
				@acceleration = on_target * 0.25
			end
			
			distance = Math.sqrt((@dest_x - @x) ** 2 + (@dest_y - @y) ** 2)
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
		@speed *= 0.9 if !@moving
		
		@last_x, @last_y = @x, @y
		@x += @speed * Math.cos(@tank_angle)
		@y += @speed * Math.sin(@tank_angle)
	end
	
	def collide_and_stop
		@x, @y = @last_x, @last_y
		hurt @speed.abs * 3 + 5
		@speed = 0
		@moving = false
	end
	
	def turn direction
		@tank_angle += [[-0.03, direction].max, 0.03].min
	end
	
	def aim direction
		@aim_angle += [[-0.1, direction].max, 0.1].min
	end
	
	def draw
		$app.stroke $app.blue
		$app.fill $app.blue(0.4)
		Opp.draw_opp_rect @x - 20, @x + 20, @y - 15, @y + 15, 1.05, @tank_angle
		#Opp.draw_opp_box @x - 20, @x + 20, @y - 20, @y + 20, 1.03, 1.0
		Opp.draw_opp_rect @x - 10, @x + 10, @y - 7, @y + 7, 1.05, @aim_angle
		x, unused1, y, unused2 = Opp.project(@x, 0, @y, 0, 1.05)
		$app.line x, y, x + 25 * Math.cos(@aim_angle), y + 25 * Math.sin(@aim_angle)
		
		$app.stroke $app.red
		$app.fill $app.red(@aimed ? 0.4 : 0.1)
		Opp.draw_opp_oval @target_x - 10, @target_x + 10, @target_y - 10, @target_y + 10, 1.00
		
		if @moving
			$app.stroke $app.green
			$app.fill $app.green(0.2)
			Opp.draw_opp_oval @dest_x - 20, @dest_x + 20, @dest_y - 20, @dest_y + 20, 1.00
		end
	end
end

class Shell
	attr_reader :x, :y
	
	def initialize x, y, angle
		@x, @y, @angle = x, y, angle
		@speed = 10.0
	end
	
	def update
		@x += @speed * Math.cos(@angle)
		@y += @speed * Math.sin(@angle)
	end
	
	def draw
		$app.stroke $app.red
		$app.fill $app.red(0.1)
		Opp.draw_opp_box @x - 2, @x + 2, @y - 2, @y + 2, 1.05, 1.04
	end
end

class Opp
	def self.new_game
		@offset_x, @offset_y = 0, 0
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
		].collect { |p| Building.new *p }
		@shells = []
		@boundary = [-1250, 1500, -1250, 1250]
		@tank = Tank.new
		@center_x, @center_y = $app.width / 2, $app.height / 2
	end
	
	def self.tank
		@tank
	end
	
	def self.read_input
		@input = $app.mouse
	end
	
	def self.update_scene
		button, x, y = @input
		x += @offset_x - @center_x
		y += @offset_y - @center_y
		
		@tank.update(button, x, y) if !@tank.dead?
		@buildings.each do |b|
			@tank.collide_and_stop if b.intersects? @tank
		end
		
		@shells.each { |s| s.update }
		@buildings.each do |b|
			@shells.reject! do |s|
				b.contains?(s.x, s.y)
			end
		end
		#collide shells with tanks -- don't need this until there are enemy tanks
		#@shells.reject! do |s|
		#	@tank.contains?(s.x, s.y)
		#end
		
		$app.clear do
			@offset_x += $camera_tightness * (@tank.x - @offset_x)
			@offset_y += $camera_tightness * (@tank.y - @offset_y)
			
			$app.background $app.black
			@center_x, @center_y = $app.width / 2, $app.height / 2
			
			$app.stroke $app.red(0.9)
			$app.nofill
			draw_opp_box *(@boundary + [1.1, 1.0, false])
			
			@tank.draw
			@shells.each { |s| s.draw }
			@buildings.each { |b| b.draw }
		end
	end
	
	def self.add_shell shell
		@shells << shell
		@shells.shift if @shells.size > 10
	end
	
	def self.project left, right, top, bottom, depth
		[left, right].collect { |x| @center_x + depth * (x - @offset_x) } +
			[top, bottom].collect { |y| @center_y + depth * (y - @offset_y) }
	end
	
	# here "front" and "back" push the rect into and out of the window.
	# 1.0 means your x and y units are pixels on the surface.
	# greater than that brings the box closer.  less pushes it back.  0.0 => infinity.
	# the front will be filled but the rest is wireframe only.
	def self.draw_opp_box left, right, top, bottom, front, back, occlude = true
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
		$app.line far_left, far_top, far_right, far_top if draw_top
		$app.line far_left, far_bottom, far_right, far_bottom if draw_bottom
		$app.line far_left, far_top, far_left, far_bottom if draw_left
		$app.line far_right, far_top, far_right, far_bottom if draw_right
		
		# draw lines to connect the front and back
		$app.line near_left, near_top, far_left, far_top if draw_left or draw_top
		$app.line near_right, near_top, far_right, far_top if draw_right or draw_top
		$app.line near_left, near_bottom, far_left, far_bottom if draw_left or draw_bottom
		$app.line near_right, near_bottom, far_right, far_bottom if draw_right or draw_bottom
		
		# draw the front, filled
		$app.rect near_left, near_top, near_right - near_left, near_bottom - near_top
	end
	
	def self.draw_opp_rect left, right, top, bottom, depth, angle, with_x = false
		pl, pr, pt, pb = project(left, right, top, bottom, depth)
		cos = Math.cos(angle)
		sin = Math.sin(angle)
		cx, cy = (pr + pl) / 2.0, (pb + pt) / 2.0
		points = [[pl, pt], [pr, pt], [pr, pb], [pl, pb]].collect do |x, y|
			[cx + (x - cx) * cos - (y - cy) * sin,
				cy + (x - cx) * sin + (y - cy) * cos]
		end
		
		$app.line *(points[0] + points[1])
		$app.line *(points[1] + points[2])
		$app.line *(points[2] + points[3])
		$app.line *(points[3] + points[0])
	end
	
	def self.draw_opp_oval left, right, top, bottom, depth
		pl, pr, pt, pb = project(left, right, top, bottom, depth)
		$app.oval(pl, pt, pr - pl, pb - pt)
	end
	
	def self.draw_opp_plane x1, y1, x2, y2, front, back, stroke_color
		near_x1, near_x2, near_y1, near_y2 = project(x1, x2, y1, y2, front)
		far_x1, far_x2, far_y1, far_y2 = project(x1, x2, y1, y2, back)
		
		$app.stroke stroke_color
		
		$app.line far_x1, far_y1, far_x2, far_y2
		$app.line far_x1, far_y1, near_x1, near_y1
		$app.line far_x2, far_y2, near_x2, near_y2
		$app.line near_x1, near_y1, near_x2, near_y2
	end
end

Shoes.app :width => $width, :height => $height do
	$app = self
	
	Opp.new_game
	@playing = true
	
	keypress do |key|
		if @playing
			if key == "1" or key == "z"
				Opp.tank.set_destination
			elsif key == "2" or key == "x" or key == " "
				Opp.tank.fire
			end
		else
			if key == "n"
				Opp.new_game
				@playing = true
			end
		end
	end
	
	click do |button, x, y|
		if @playing
			if button == 1
				Opp.tank.set_destination
			else
				Opp.tank.fire
			end
		end
	end
	
	game_over_count = -1
	animate(60) do
		Opp.read_input if @playing
		Opp.update_scene
		
		@playing = false if Opp.tank.dead?
		if !@playing
			stack do
				banner "Game Over", :stroke => white, :margin => 10
				caption "learn to drive!", :stroke => white, :margin => 20
			end
		end
	end
end
