
#  
#  Shoes TicTactoe
#  

# Global Constants and Variables

PADDING = 10
TIC_SIZE = 60
$player = 0
$click = false
$player_para = nil
$animation

# Player Module - yet to be exported

def toggle_player
	if $player == 0
		$player = 1
		$player_para.replace "Player Yellow"
	else
		$player = 0
		$player_para.replace "Player Blue"
	end
end

def player_symbol
	if $player == 0
		'X'
	else
		'O'
	end
end

def check_if_over
	diagonal_tics = []
	diagonal_tacs = []
	(1..3).each do |i|
		tics = Tic.find_x(i).select { |tic| tic.checked == 'X' }
		return true if tics.length > 2
		tics = Tic.find_x(i).select { |tic| tic.checked == 'O' }
		return true if tics.length > 2
		tics = Tic.find_y(i).select { |tic| tic.checked == 'X' }
		return true if tics.length > 2
		tics = Tic.find_y(i).select { |tic| tic.checked == 'O' }
		return true if tics.length > 2
		diagonal_tics << Tic.find(i,i)
		diagonal_tacs << Tic.find(4-i, i)
	end
	tics = diagonal_tacs.select { |tic| tic.checked == 'X' }
	return true if tics.length > 2
	tics = diagonal_tacs.select { |tic| tic.checked == 'O' }
	return true if tics.length > 2
	tics = diagonal_tics.select { |tic| tic.checked == 'X' }
	return true if tics.length > 2
	tics = diagonal_tics.select { |tic| tic.checked == 'O' }
	return true if tics.length > 2
	
	false
end

def check_if_full
	tics = Tic.tics.select { |tic| tic.checked }
	tics.length == 9
end


# Tic Class - yet to be exported

class Tic
	attr_accessor :x, :y, :width, :height, :checked, :rect
	
	@@tics = []
	
	def initialize(x, y, width = 60, height = nil, checked = false)
		if height
			@height = height
		else
			@height = width
		end
		@x = x
		@y = y
		@top = (PADDING + TIC_SIZE) * x
		@left = (PADDING + TIC_SIZE) * y
		@width = width
		@checked = false
		@@tics << self
	end
	
	def draw(app)
		@rect = app.rect @top, @left, @width, @height, 5 # Last one's border radius
		
		@rect.click do
			unless $click or @checked
				@checked = player_symbol
				toggle_player
				$click = true
				if check_if_over
					
					@app_rect = app.rect 0,0,$width,$width, fill: app.rgb(0,0,0,0.7)
					if $player == 1
						player = 'Blue'
					else
						player = 'Yellow'
					end
					@title = app.title "#{player} won!", stroke: app.white, top: 90, left: 88, size: 34
					@quit = app.button 'Quit', top:165, left:138 do
						exit
					end
					@restart = app.button 'Restart', top:140, left:130 do
						Tic.restart app
						@app_rect.hide
						@title.hide
						@quit.hide
						@restart.hide
						if $player == 1
							toggle_player
						end
					end
				elsif check_if_full
					@app_rect = app.rect 0,0,$width,$width, fill: app.rgb(0,0,0,0.6)
					@quit = app.button 'Quit', top:165, left:138 do
						exit
					end
					@title = app.title "Cat's Game!", stroke: app.white, top: 90, left: 80, size: 34
					@restart = app.button 'Restart', top:140, left:130 do
						Tic.restart app
						@app_rect.hide
						@title.hide
						@quit.hide
						@restart.hide
						if $player == 1
							toggle_player
						end
					end
				end
			end
		end
		
		@rect.release do
			$click = false
		end
		
	end
	
	def self.make_board(app)
		
		fill = app.black
	
		3.times do |i|
		
			3.times do |j|
			
				Tic.new(j+1, i+1, TIC_SIZE).draw app
			
			end
		
		end
		
	end
	
	def self.redraw(app)
		@@tics.each do |tic|
			if tic.checked == 'X'
				tic.rect.style fill: app.cyan
			elsif tic.checked == 'O'
				tic.rect.style fill: app.yellow
			end
		end
	end
	
	def self.restart(app)
		@@tics.each do |tic|
			tic.checked = false
			tic.rect.style fill: app.black
		end
	end
	
	def self.find_x(x)
		@@tics.select { |tic| tic.x == x }
	end
	
	def self.find_y(y)
		@@tics.select { |tic| tic.y == y }
	end
	
	def self.find(x,y)
		@@tics.select { |tic| tic.x == x and tic.y  == y }[0]
	end
	
	def self.tics
		@@tics
	end
	
end

# Main GUI App

width = height = $width = (PADDING * 4) + (TIC_SIZE * 5)

Shoes.app width: width, height: height, title: 'Tic Tac Toe' do
	background gradient(slategray, slateblue)
	
	stroke white
	
	title 'Tic Tac Toe', left: 85, family: 'Lacuna', top: 10
	
	flow bottom: 10, left: 120 do
	$player_para = para 'Player Blue', size: 20
	end
	
	stroke app.black
	
	Tic.make_board self
	
	$animation = animate do 
		Tic.redraw self
	end
	
end
