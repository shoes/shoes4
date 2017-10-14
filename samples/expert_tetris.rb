# frozen_string_literal: true

#==================================================================================================
#
# A Tetris game for Ruby Shoes
#
# Controls:
#
#  left/right - slide the piece horizontally
#  up - rotate the piece 90 degrees clockwise
#  down - drop the piece faster
#  esc - quit the game
#
# For more details see http://codeincomplete.com/posts/2014/11/7/tetris_shoes/
#

#==================================================================================================
# Game Constants
#==================================================================================================

WIDTH  = 300            # width  of tetris court (in pixels)
HEIGHT = 600            # height of tetris court (in pixels)
NX     = 10             # width  of tetris court (in blocks)
NY     = 20             # height of tetris court (in blocks)
DX     = WIDTH / NX     # pixel width  of a single tetris block
DY     = HEIGHT / NY    # pixel height of a single tetris block
FPS    = 60             # game animation frame rate (fps)

PACE   = { start: 0.5, step: 0.005, min: 0.1 }.freeze # how long before a piece drops by 1 row (seconds)
SCORE  = { line: 100, multiplier: 2 }.freeze          # score per line removed (100) and bonus multiplier when multiple lines cleared in a the same drop

#==================================================================================================
# The 7 Tetromino Types
#==================================================================================================
#
# blocks: each element represents a rotation of the piece (0, 90, 180, 270)
#         each element is a 16 bit integer where the 16 bits represent
#         a 4x4 set of blocks, e.g. j.blocks[0] = 0x44C0
#
#             0100 = 0x4 << 3 = 0x4000
#             0100 = 0x4 << 2 = 0x0400
#             1100 = 0xC << 1 = 0x00C0
#             0000 = 0x0 << 0 = 0x0000
#                               ------
#                               0x44C0
#
#  (see http://codeincomplete.com/posts/2011/10/10/javascript_tetris/)
#

I = { blocks: {up: 0x0F00, right: 0x2222, down: 0x00F0, left: 0x4444}, color: '#00FFFF', size: 4 }.freeze
J = { blocks: {up: 0x44C0, right: 0x8E00, down: 0x6440, left: 0x0E20}, color: '#0000FF', size: 3 }.freeze
L = { blocks: {up: 0x4460, right: 0x0E80, down: 0xC440, left: 0x2E00}, color: '#FF8000', size: 3 }.freeze
O = { blocks: {up: 0xCC00, right: 0xCC00, down: 0xCC00, left: 0xCC00}, color: '#FFFF00', size: 2 }.freeze
S = { blocks: {up: 0x06C0, right: 0x8C40, down: 0x6C00, left: 0x4620}, color: '#00FF00', size: 3 }.freeze
T = { blocks: {up: 0x0E40, right: 0x4C40, down: 0x4E00, left: 0x4640}, color: '#8040FF', size: 3 }.freeze
Z = { blocks: {up: 0x0C60, right: 0x4C80, down: 0xC600, left: 0x2640}, color: '#FF0000', size: 3 }.freeze

#==================================================================================================
# The Game Runner
#==================================================================================================

class Tetris
  attr_reader :dt,       # time since the current active piece last dropped a row
              :score,    # the current score
              :lost,     # bool to indicate when the game is lost
              :pace,     # current game pace - how long until the current piece drops a single row
              :blocks,   # 2 dimensional array (NX*NY) represeting the tetris court - either empty block or occupied by a piece
              :actions,  # queue of user inputs collected by the game loop
              :bag,      # a collection of random pieces to be used
              :current   # the current active piece

  #----------------------------------------------------------------------------

  def initialize
    @dt      = 0
    @score   = 0
    @pace    = PACE[:start]
    @blocks  = Array.new(NX) { Array.new(NY) } # awkward way to initialize an already sized 2 dimensional array
    @actions = []
    @bag     = new_bag
    @current = random_piece
  end

  #----------------------------------------------------------------------------

  def update(seconds)
    action = actions.shift
    case action
    when :left   then move(:left)
    when :right  then move(:right)
    when :rotate then rotate
    when :drop   then drop
    end

    @dt += seconds
    if dt > pace
      @dt = dt - pace
      drop
    end
  end

  #----------------------------------------------------------------------------

  def move(direction)
    nextup = current.move(direction)
    if unoccupied(nextup)
      choose_new_piece(nextup)
      true
    end
  end

  def rotate
    nextup = current.rotate
    if unoccupied(nextup)
      choose_new_piece(nextup)
      true
    end
  end

  def drop
    unless move(:down)
      finalize_piece
      reward_for_piece
      remove_any_completed_lines
      clear_pending_actions
      choose_new_piece
      lose if occupied(current)
    end
  end

  #----------------------------------------------------------------------------

  def unoccupied(piece)
    !occupied(piece)
  end

  def occupied(piece)
    piece.each_occupied_block do |x, y|
      if x.negative? || (x >= NX) || y.negative? || (y >= NY) || blocks[x][y]
        return true
      end
    end
    false
  end

  #----------------------------------------------------------------------------

  def finalize_piece
    current.each_occupied_block { |x, y| blocks[x][y] = current.tetromino }
  end

  def choose_new_piece(piece = nil)
    @current = piece || random_piece
  end

  def reward_for_piece
    @score = score + 10
  end

  def reward_lines(lines)
    @score = score + (SCORE[:line] * SCORE[:multiplier]**(lines - 1)) # e.g. 1: 100, 2: 200, 3: 400, 4: 800
    @pace  = [pace - lines * PACE[:step], PACE[:min]].max
  end

  def clear_pending_actions
    actions.clear
  end

  def lose
    @lost = true
  end

  def lost?
    @lost
  end

  def new_bag
    [I, I, I, I, J, J, J, J, L, L, L, L, O, O, O, O, S, S, S, S, T, T, T, T, Z, Z, Z, Z].shuffle
  end

  def random_piece
    @bag = new_bag if bag.empty?
    Piece.new(bag.pop)
  end

  #----------------------------------------------------------------------------

  def remove_any_completed_lines
    lines = 0
    NY.times do |y|
      unless NX.times.any? { |x| blocks[x][y].nil? }
        remove_line(y)
        lines += 1
      end
    end
    reward_lines(lines) unless lines.zero?
  end

  def remove_line(n)
    n.downto(0) do |y|
      NX.times do |x|
        blocks[x][y] = y.zero? ? nil : blocks[x][y - 1]
      end
    end
  end

  #----------------------------------------------------------------------------

  def each_occupied_block
    NY.times do |y|
      NX.times do |x|
        yield x, y, blocks[x][y][:color] unless blocks[x][y].nil?
      end
    end
  end
end # class Tetris

#==================================================================================================
# A Game Piece
#==================================================================================================

class Piece
  attr_reader :tetromino,  # the tetromino type
              :direction,  # the rotation direction (:up, :down, :left, :right)
              :x, :y       # the (x,y) position on the board

  #----------------------------------------------------------------------------

  def initialize(tetromino, x = nil, y = nil, direction = nil)
    @tetromino = tetromino
    @direction = direction || :up
    @x         = x         || rand(NX - tetromino[:size]) # default to a random horizontal position (that fits)
    @y         = y         || 0
  end

  #----------------------------------------------------------------------------

  def rotate
    newdir = case direction
             when :left  then :up
             when :up    then :right
             when :right then :down
             when :down  then :left
             end
    Piece.new(tetromino, x, y, newdir)
  end

  def move(direction)
    case direction
    when :right then Piece.new(tetromino, x + 1, y,     @direction)
    when :left  then Piece.new(tetromino, x - 1, y,     @direction)
    when :down  then Piece.new(tetromino, x,     y + 1, @direction)
    end
  end

  #----------------------------------------------------------------------------

  def each_occupied_block # a bit complex, for more details see - http://codeincomplete.com/posts/2011/10/10/javascript_tetris/
    bit = 0b1000000000000000
    row = 0
    col = 0
    blocks = tetromino[:blocks][direction]
    until bit.zero?
      yield x + col, y + row if (blocks & bit) == bit
      col += 1
      if col == 4
        col = 0
        row += 1
      end
      bit = bit >> 1
    end
  end
end # class Piece

#==================================================================================================
# The SHOES application
#==================================================================================================

Shoes.app title: 'Tetris', width: WIDTH, height: HEIGHT do
  game = Tetris.new

  keypress do |k|
    case k
    when :left   then game.actions << :left
    when :right  then game.actions << :right
    when :down   then game.actions << :drop
    when :up     then game.actions << :rotate
    when :escape then quit
    end
  end

  def block(x, y, color)
    fill color
    rect(x * DX, y * DY, DX, DY)
  end

  last = Time.now
  animate = animate FPS do
    now = Time.now

    game.update(now - last)
    clear

    game.each_occupied_block do |x, y, color|
      block(x, y, color)
    end

    game.current.each_occupied_block do |x, y|
      block(x, y, game.current.tetromino[:color])
    end

    if game.lost?
      banner "Game Over", align: 'center', stroke: black
      animate.stop
    else
      subtitle "Score: #{format('%6.6d', game.score)}", stroke: green, align: 'right'
    end

    last = now
  end
end

#==================================================================================================
