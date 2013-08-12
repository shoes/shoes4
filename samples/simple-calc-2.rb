Shoes.app height: 250, width: 198 do
  def do_calc
    @number = @previous.send(@op, @number)  if @op
    @op = nil
  end

  @previous, @number, @op = 0, 0, nil
  background rgb(235, 235, 210)
  flow margin: 5 do
    flow height: 240, width: 190, margin: [2, 5, 0, 0] do
      background "#996".."#333", curve: 5
      number_field = para strong(@number, ' '*20), stroke: white, margin: 8
      flow width: 218 do
        %w(7 8 9 / 4 5 6 * 1 2 3 - 0 Clr = +).each do |btn|
          button btn, width: 46, height: 46 do
            case btn
            when /[0-9]/
              @number = @number.to_i * 10 + btn.to_i
            when 'Clr'
              @previous, @number, @op = 0, 0, nil
            when '='
              do_calc
            else
              do_calc
              @previous, @number = @number, nil
              @op = btn
            end
            number_field.text = @number.to_s
          end
        end
      end
    end
  end
end
