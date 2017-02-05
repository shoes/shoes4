# frozen_string_literal: true
Shoes.app height: 250, width: 198 do
  def clear
    @accumulator = 0
    @display = 0
    @op = nil
  end

  def do_calc
    @display = @accumulator.send(@op, @display) if @op

    @op = nil
  end

  clear
  @clear_display = false
  background rgb(235, 235, 210)
  flow margin: 5 do
    flow height: 240, width: 190, margin: [2, 5, 0, 0] do
      background '#996'..'#333', curve: 5
      number_field = para strong(@display, ' ' * 20), stroke: white, margin: 8
      flow width: 218 do
        %w(7 8 9 / 4 5 6 * 1 2 3 - 0 Clr = +).each do |btn|
          button btn, width: 46, height: 46 do
            case btn
            when /[0-9]/
              if @clear_display
                @display = 0
                @clear_display = false
              end
              @display = @display.to_i * 10 + btn.to_i
            when 'Clr'
              clear
            when '='
              do_calc
              @clear_display = true
            when '/', '*', '-', '+'
              do_calc
              @accumulator = @display
              @op = btn
              @clear_display = true
            end
            number_field.text = @display.to_s
          end
        end
      end
    end
  end
end
