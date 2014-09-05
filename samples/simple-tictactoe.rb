# Size module
# Change these constants to change the size of the board.
module SIZE
  PADDING = 10
  TIC_SIZE = 60
  B_RADIUS = 5
  WIDTH = HEIGHT = (PADDING * 4) + (TIC_SIZE * 5)
end

class Tic
  attr_reader :x, :y, :checked, :rect, :player

  def initialize(tic)
    @rect = tic[0]
    @x = tic[1]
    @y = tic[2]
    @player = false
    @checked = false
  end

  def check
    @checked = true
  end

  def reset
    @player = false
    @checked = false
    @rect.style fill: '#000000'
  end

  def player=(symbol)
    @player = symbol
    if symbol == 'X'
      @rect.style fill: '#00FFFF'
    else
      @rect.style fill: '#FFFF44'
    end
  end

end


# Mostly keeps track of the Player.
# 'class Player' would imply two.
class Game

  def initialize(player_label)
    @player = false
    @label = player_label
  end

  def restart
    @player = true and toggle_player # English syntax!
  end

  def toggle_player
    @player = !@player
    @label.text = player_turn
  end

  def player_symbol
    @player ? 'X' : 'O'
  end

  def player_color
    @player ? "Yellow" : "Blue"
  end

  def player_turn
    "#{player_color}'s Turn"
  end

  def player_win
    @player =! @player
    "#{player_color} won!"
  end

end


# Organizes the Tics and
# checks for winning configurations
class Board
  attr_reader :game

  def initialize(tics, player_label)
    @tics = []
    @over = false
    @game = Game.new player_label

    tics.each do |tic| # Each tic in this array is of the format: [rect, x, y]
      @tics << Tic.new(tic)
    end

  end

  # Actions for each of the tic's rectangle
  def set_tic_actions
    @tics.each do |tic|
      tic.rect.click do
        unless tic.checked or @over
          @game.toggle_player
          tic.player = @game.player_symbol
          tic.check
          if self.check_if_over
            show_screen(game.player_win)
          elsif self.full?
            show_screen("Cat's Game!")
          end
        end
      end
    end
  end

  def check_if_over
    (1..3).any? { |i| all_checked?(row(i)) || all_checked?(column(i)) } ||
      all_checked?(diagonal1) ||
      all_checked?(diagonal2)
  end

  # Takes an array and tells if each Tic has been checked by the same player
  def all_checked?(array)
    if array[0].checked
      return array[0].player == array[1].player && array[1].player == array[2].player
    else
      return false
    end
  end


  # In this case, the screen is the
  # end screen, including the transparent
  # black panel and its buttons.
  def set_screen(screen)
    @screen = screen
  end

  def clear_screen
    @screen.each do |item|
      item.hide
    end
  end

  def show_screen(title)
    @over = true
    @screen.each do |item|
      item.show
    end
    @screen[0].text = title
  end

  def restart
    clear_screen
    @over = false
    @tics.each do |tic|
      tic.reset
    end
    game.restart
  end

  def row(x)
    @tics.select { |tic| tic.x == x }
  end

  def column(y)
    @tics.select { |tic| tic.y == y }
  end

  def diagonal1
    tics = []
    (1..3).each do |i|
      tics.concat(@tics.select { |tic| tic.x == i && tic.y == i })
    end
    tics
  end

  def diagonal2
    tics = []
    (1..3).each do |i|
      tics.concat(@tics.select { |tic| tic.x == i && tic.y == (4 - i) })
    end
    tics
  end

  def full?
    @tics.select { |tic| tic.checked }.length == 9
  end
end


# Main GUI App
Shoes.app width: SIZE::WIDTH, height: SIZE::HEIGHT, title: 'Tic Tac Toe' do
  background gradient(slategray, slateblue)

  stroke white

  title 'Tic Tac Toe', align: 'center', family: 'Lacuna', top: 10

  flow bottom: 10 do
    @player_label = para "Blue's Turn", size: 20, align: 'center'
  end

  stroke black

  # The making of the Tic rectangles, along with a record of their coordinates.
  tics = []
  (1..3).each do |i|
    (1..3).each do |j|
      rectangle = rect((SIZE::PADDING + SIZE::TIC_SIZE) * i, (SIZE::PADDING + SIZE::TIC_SIZE) * j, SIZE::TIC_SIZE, SIZE::TIC_SIZE, SIZE::B_RADIUS)
      tics << [rectangle, i, j]
    end
  end


  stroke black

  board = Board.new(tics, @player_label) # player_label is passed on to the game.

  board.set_tic_actions

  # End Screen
  black_screen = rect 0,0,SIZE::WIDTH,SIZE::WIDTH, fill: app.rgb(0,0,0,0.5)
  flow align: 'center' do
    # Positioned oddly because 'align: "center"' appears not to work on buttons
    @quit_button = button 'Quit', top: 174, left: (SIZE::WIDTH/2 - 34) do
      exit
    end
    # Positioned oddly because 'align: "center"' appears not to work on buttons
    @restart_button = button 'Restart', top: 140, align: 'center', left: (SIZE::WIDTH/2 - 43) do
      board.restart
    end
  end
  alert_title = title "Cat's Game!", stroke: white, top: 90, align: 'center', size: 34
  exit_screen = [alert_title, black_screen, @quit_button, @restart_button]

  board.set_screen(exit_screen) # Passes pre-made gui on for later use
  board.clear_screen # Clears it to begin with
end
