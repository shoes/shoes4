# Othello
# by tieg
# 1/13/08
# with help: DeeJay, Ryan M. from mailing list
#
# FIXME bug if it memorizes it but it's not a valid move
#
module Othello

  PIECE_WIDTH  = 62
  PIECE_HEIGHT = 62
  TOP_OFFSET = 47
  LEFT_OFFSET = 12

  class Game
    BOARD_SIZE = [8,8]

    attr_accessor :p1, :p2, :board, :board_history
        
    def initialize
      @board_history = []
      @p1            = Player.new(:black, pieces_per_player)
      @p2            = Player.new(:white, pieces_per_player)
      @board         = new_board
      lay_initial_pieces
    end

    def next_turn(check_available_moves=true)
      @current_player = next_player
      if check_available_moves && skip_turn?
        # FIXME Possible infinite loop if neither player has a good move?
        next_turn
        raise "Player #{@current_player.piece} (#{@current_player.color}) has no available moves. Player #{next_player.piece}'s (#{next_player.color}) turn."
      end
    end

    def current_player
      @current_player ||= @p1
    end

    def next_player
      current_player == @p1 ? @p2 : @p1
    end

    # Build the array for the board, with zero-based arrays.
    def new_board
      Array.new(BOARD_SIZE[0]) do # build each cols L to R
        Array.new(BOARD_SIZE[1]) do # insert cells in each col
          0
        end
      end
    end
    
    # Lay the initial 4 pieces in the middle
    def lay_initial_pieces
      lay_piece([4, 3], false)
      next_turn(false)
      lay_piece([3, 3], false)
      next_turn(false)
      lay_piece([3, 4], false)
      next_turn(false)
      lay_piece([4, 4], false)
      next_turn(false)
    end
    
    def lay_piece(c=[0,0], check_adjacent_pieces=true)
      memorize_board
      piece = current_player.piece
      opp_piece = current_player.opp_piece
      raise "Spot already taken." if board_at(c) != 0
      if check_adjacent_pieces
        pieces_to_change = []
        pieces_to_change << check_direction(c, [ 0, 1], piece, opp_piece) # N
        pieces_to_change << check_direction(c, [ 1, 1], piece, opp_piece) # NE
        pieces_to_change << check_direction(c, [ 1, 0], piece, opp_piece) # E
        pieces_to_change << check_direction(c, [ 1,-1], piece, opp_piece) # SE
        pieces_to_change << check_direction(c, [ 0,-1], piece, opp_piece) # S
        pieces_to_change << check_direction(c, [-1,-1], piece, opp_piece) # SW
        pieces_to_change << check_direction(c, [-1, 0], piece, opp_piece) # W
        pieces_to_change << check_direction(c, [-1, 1], piece, opp_piece) # NW
        raise "You must move to a spot that will turn your opponent's piece." if pieces_to_change.compact.all? { |a| a.empty? }
        pieces_to_change.compact.each { |direction| direction.each { |i| @board[i[0]][i[1]] = piece } }
      end
      current_player.pieces -= 1
      @board[c[0]][c[1]] = piece
      current_winner = calculate_current_winner
      raise "Game over. Player #{current_winner.piece} wins with #{current_winner.pieces_on_board} pieces!" if @p1.pieces + @p2.pieces == 0
    end
    
    def skip_turn?
      possibles = []
      @board.each_with_index { |col,col_index| 
        col.each_with_index { |cell,row_index| 
          return false if possible_move?([col_index,row_index])
        } 
      }
      true
    end
    
    def possible_move?(c=[0,0])
      return nil if board_at(c) != 0
      possible_moves = []
      piece = current_player.piece
      opp_piece = current_player.opp_piece
      pieces_to_change = []
      pieces_to_change << check_direction(c, [ 0, 1], piece, opp_piece) # N
      pieces_to_change << check_direction(c, [ 1, 1], piece, opp_piece) # NE
      pieces_to_change << check_direction(c, [ 1, 0], piece, opp_piece) # E
      pieces_to_change << check_direction(c, [ 1,-1], piece, opp_piece) # SE
      pieces_to_change << check_direction(c, [ 0,-1], piece, opp_piece) # S
      pieces_to_change << check_direction(c, [-1,-1], piece, opp_piece) # SW
      pieces_to_change << check_direction(c, [-1, 0], piece, opp_piece) # W
      pieces_to_change << check_direction(c, [-1, 1], piece, opp_piece) # NW
      return nil if pieces_to_change.compact.all? { |a| a.empty? }
      true
    end
    
    def memorize_board
      dup_board = new_board
      dup_board = []
      @board.each do |col|
        dup_board << col.dup
      end
      @board_history << { :player => current_player, :board => dup_board }
    end

    def undo!
      last_move = @board_history.pop
      @board = last_move[:board]
      @current_player = last_move[:player]
      @current_player.pieces += 1
    end

    def calculate_current_winner
      @p1.pieces_on_board, @p2.pieces_on_board = 0, 0
      @board.each { |row| 
        row.each { |cell|
          if cell == 1
            @p1.pieces_on_board += 1
          else 
            @p2.pieces_on_board += 1
          end
        }
      }
      @p1.pieces_on_board > @p2.pieces_on_board ? @p1 : @p2
    end

    def check_direction(c, dir, piece, opp_piece)
      c_adjacent = next_in_direction(c.dup, dir)
      c_last = nil
      pieces_in_between = []
      # Find the last piece if there is one.
      while(valid_location?(c_adjacent))
        if board_at(c_adjacent) == opp_piece
          pieces_in_between << c_adjacent.dup
        elsif board_at(c_adjacent) == piece && pieces_in_between.size > 0
          c_last = c_adjacent
          break
        else
          break
        end
        c_adjacent = next_in_direction(c_adjacent, dir)
      end

      pieces_in_between.empty? || c_last.nil? ? nil : pieces_in_between
    end
    
    # Find the value of the board at the given coordinate.
    def board_at(c)
      @board[c[0]][c[1]]
    end

    # Is this a valid location on board?
    def valid_location?(c=[1,1])
      c[0] >= 0 && c[1] >= 0 && c[0] < BOARD_SIZE[0] && c[1] < BOARD_SIZE[1]
    end

    # Perform the operations to get the next spot in the appropriate direction
    def next_in_direction(c, dir)
      c[0] += dir[0]
      c[1] += dir[1]
      c
    end

    private
    def pieces_per_player
      total_squares / 2
    end
    
    # The total number of squares
    def total_squares
      BOARD_SIZE[0] * BOARD_SIZE[1]
    end

    class Player
      attr_accessor :pieces, :color, :pieces_on_board

      def initialize(color=:black,pieces=0)
        @pieces = pieces
        @pieces_on_board = 0 # used only in calculating winner
        @color = color
      end
      
      def piece
        color == :black ? 1 : 2
      end
      
      def opp_piece
        color == :black ? 2 : 1
      end
    end 
  end

  def draw_player_1(first_turn=false)
    stack :margin => 10 do
      if GAME.current_player==GAME.p1
        background yellow
        para span("Player 1 (#{GAME.current_player.color}) turn", :stroke => black, :font => "Trebuchet 20px bold"), :margin => 4
      else
        background white
        para span("Player 1", :stroke => black, :font => "Trebuchet 10px bold"), :margin => 4

        button("Undo last move", :top => 0, :left => -150) { GAME.undo!; draw_board } unless GAME.board_history.empty?
      end
    end
  end

  def draw_player_2(first_turn=false)
    stack :top => 550, :left => 0, :margin => 10 do
      if GAME.current_player==GAME.p2 
        background yellow
        para span("Player 2's (#{GAME.current_player.color}) turn", :stroke => black, :font => "Trebuchet 20px bold"), :margin => 4
      else
        background white
        para span("Player 2", :stroke => black, :font => "Trebuchet 10px bold"), :margin => 4

        button("Undo last move", :top => 0, :left => -150) { GAME.undo!; draw_board } unless GAME.board_history.empty?
      end
    end
  end


  def draw_board
    clear do
      background black
      draw_player_1
      stack :margin => 10 do
        fill rgb(0, 190, 0)
        rect :left => 0, :top => 0, :width => 495, :height => 495

        GAME.board.each_with_index do |col, col_index|
          col.each_with_index do |cell, row_index|
            left, top = left_top_corner_of_piece(col_index, row_index)
            left = left - LEFT_OFFSET
            top = top - TOP_OFFSET
            fill rgb(0, 440, 0, 90)
            strokewidth 1
            stroke rgb(0, 100, 0)
            rect :left => left, :top => top, :width => PIECE_WIDTH, :height => PIECE_HEIGHT

            if cell != 0
              strokewidth 0
              fill (cell == 1 ? rgb(100,100,100) : rgb(155,155,155))
              oval(left+3, top+4, PIECE_WIDTH-10, PIECE_HEIGHT-10)

              fill (cell == 1 ? black : white)
              oval(left+5, top+5, PIECE_WIDTH-10, PIECE_HEIGHT-10)
            end
          end
        end
      end
      draw_player_2
    end
  end

  def left_top_corner_of_piece(a,b)
    [(a*PIECE_WIDTH+LEFT_OFFSET), (b*PIECE_HEIGHT+TOP_OFFSET)]
  end

  def right_bottom_corner_of_piece(a,b)
    left_top_corner_of_piece(a,b).map { |coord| coord + PIECE_WIDTH }
  end

  def find_piece(x,y)
    GAME.board.each_with_index { |row_array, row| 
      row_array.each_with_index { |col_array, col| 
        left, top = left_top_corner_of_piece(col, row).map { |i| i - 5}
        right, bottom = right_bottom_corner_of_piece(col, row).map { |i| i -5 }
        return [col, row] if x >= left && x <= right && y >= top && y <= bottom
      } 
    }
    return false
  end

  GAME = Othello::Game.new
end


Shoes.app :width => 520, :height => 600 do
  extend Othello

  draw_board
  
  click { |button, x, y| 
    if coords = find_piece(x,y)
      begin
        GAME.lay_piece(coords)
        GAME.next_turn
        draw_board
      rescue => e
        draw_board
        alert(e.message)
      end
    else
      # alert("Not a piece.")
    end
  }
end

