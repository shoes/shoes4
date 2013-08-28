# Simple Game of Life with Shoes
# by fuksito
# vitaliy@yanchuk.me


class Cell
  WIDTH = 15
  attr_accessor :live, :next_state, :y, :x, :neighbours, :live_neighbours, :app, :shoes_cell

  def initialize(y, x, app, world)
    @live = false
    @next_state = false
    @y = y
    @x = x
    @app = app
    @world = world
    @shoes_cell = @app.rect(left: WIDTH * y, top: WIDTH * x, width: WIDTH)
    @shoes_cell.click{ toggle_state }
  end

  def live?
    @live
  end

  def dead?
    !@live
  end

  def die!
    @next_state = false
    @world.changed_cells.push(self)
  end

  def alive!
    @next_state = true
    @world.changed_cells.push(self)
  end

  def toggle_state
    @next_state = !@live
    set_next_state
    draw
  end

  def set_next_state
    if @live = @next_state
      @world.live_cells.push(self)
    else
      cell_index = @world.live_cells.index(self)
      if cell_index
        @world.live_cells.delete_at(cell_index)
      end
    end
  end
  
  def draw
    @shoes_cell.style(fill: live? ? '#000' : '#fff')
  end

  def iterate
    live_cells_count = @neighbours.count{|c| c.live? }
    if live?
      if live_cells_count < 2 || live_cells_count > 3
        die!
      end
    else
      if live_cells_count == 3
        alive!
      end
    end
  end
end

class World
  attr_accessor :board, :width, :height, :live_cells, :changed_cells

  def initialize(width, height, app)
    @board = []
    @width = width
    @height = height
    @app = app
    @live_cells = []
    @changed_cells = []
    create_board
  end

  def create_board
    @height.times do |y|
      @board[y] = []
      @width.times do |x|
        @board[y][x] = Cell.new(y, x, @app, self)
      end
    end
    cells.each do |cell|
      cell.neighbours = cell_neighbours(cell.y, cell.x)
    end
    draw
  end

  def cells
    @cells ||= @board.flatten
  end

  def actual_cells
    (@live_cells.map(&:neighbours).flatten + @live_cells).uniq
  end

  def draw
    cells.each{|c| c.draw }
  end

  def tick
    @changed_cells = []
    actual_cells.each{|c| c.iterate }.each{|c| c.set_next_state }
    @changed_cells.each{|c| c.draw }
  end

  def clear
    live_cells.each do |cell|
      cell.live = false
      cell.next_state = false
      cell.draw
    end
  end

  def cell_neighbours(y,x)
    result = []
    top_row = y - 1
    left_col = x - 1
    right_col = x + 1
    bottom_row = y + 1

    if top_row >= 0 && left_col >= 0
      result << @board[y-1][x-1]
    end

    if top_row >= 0
      result << @board[y-1][x]
    end

    if top_row >= 0 && right_col < @width
      result << @board[y-1][x+1]
    end

    if left_col >= 0
      result << @board[y][x-1]
    end

    if right_col < @width
      result << @board[y][x+1]
    end

    if bottom_row < @height && left_col >= 0
      result << @board[y+1][x-1]
    end

    if bottom_row < @height
      result << @board[y+1][x]
    end

    if bottom_row < @height && right_col < @width
      result << @board[y+1][x+1]
    end

    result.compact
  end

  def add_specie(*cells)
    cells.each do |y,x|
      @board[y][x].toggle_state
    end
  end

  def add_glinder
    add_specie [4,2], [4,3], [4,4], [3,4], [2,3]
  end

  def add_spaceship
    add_specie [12,3], [12,6], [13,7], [14,3], [14,7], [15,4], [15,5], [15,6], [15,7]
  end

  def add_diehard
    add_specie [18,12], [12,13], [13,13], [13,14], [17,14], [18,14], [19,14]
  end
end

Shoes.app(title: "The Game of Life", width: 800, height: 620, resizable: false) do
  background white
  @animate = false
  stack(margin: 10) do |board_holder|
    @new_world = World.new(40, 40, self)
    animate(10) do |frame|
      if @animate
        @new_world.tick
      end
    end
  end

  def play
    @animate = true
    @run_button.style(displace_top: -100)
    @stop_button.style(displace_top: 0)
  end

  def stop
    @animate = false
    @stop_button.style(displace_top: -100)
    @run_button.style(displace_top: 0)
  end

  def clear
    stop
    @new_world.clear
  end

  flow(displace_left: 650) do
    @run_button  = button('Run',  displace_top: 0,                         width: 100){ play }
    @stop_button = button('Stop', displace_top: -100, displace_left: -100, width: 100){ stop }
  end

  stack(displace_left: 650) do
    button('Clear', width: 100) do
      clear
    end

    para "Species"
    button('Glinder', width: 100) do
      clear
      @new_world.add_glinder
    end

    button('Spaceship', width: 100) do
      clear
      @new_world.add_spaceship
    end

    button('Diehard', width: 100) do
      clear
      @new_world.add_diehard
    end
  end

end