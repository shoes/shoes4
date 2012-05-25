class Calc
  def initialize
    @number = 0
    @previous = nil
    @op = nil
  end

  def to_s
    @number.to_s
  end
  
  (0..9).each do |n|
    define_method "press_#{n}" do
      @number = @number.to_i * 10 + n
    end
  end

  def press_clear
    @number = 0
  end

  {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
    define_method "press_#{meth}" do
      if @op
        press_equals
      end
      @op = op
      @previous, @number = @number, nil
    end
  end

  def press_equals
    @number = @previous.send(@op, @number.to_i)
    @op = nil
  end

end

number_field = nil
number = Calc.new
Shoes.app :height => 250, :width => 200, :resizable => false do
  background "#EEC".."#996", :curve => 5, :margin => 2

  stack :margin => 2 do

    stack :margin => 8 do
      number_field = para strong(number)
    end

    flow :width => 218, :margin => 4 do
      %w(7 8 9 / 4 5 6 * 1 2 3 - 0 Clr = +).each do |btn|
        button btn, :width => 46, :height => 46 do
          method = case btn
            when /[0-9]/; 'press_'+btn
            when 'Clr'; 'press_clear'
            when '='; 'press_equals'
            when '+'; 'press_add'
            when '-'; 'press_sub'
            when '*'; 'press_times'
            when '/'; 'press_div'
          end
          
          number.send(method)
          number_field.replace strong(number)
        end
      end
    end
  end

end
