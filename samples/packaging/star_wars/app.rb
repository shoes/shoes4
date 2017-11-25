# frozen_string_literal: true

#
# Original code paired on by Coraline and Jason Clark, 2014
# https://youtu.be/jAnSsNga5Nk
#
require 'characters/vader'
require 'characters/yoda'
require 'characters/leia'

Shoes.app width: 800 do
  background white

  @vader = Vader.new(self)
  @yoda = Yoda.new(self)
  @leia = Leia.new(self)

  keypress do |key|
    case key
    when "d"
      @vader.saber_right
    when "D"
      @vader.saber_left
    when "y"
      @yoda.ears_down
    when "Y"
      @yoda.ears_up
    when "l"
      @leia.open_saber
    when "L"
      @leia.close_saber
    end
  end
end
