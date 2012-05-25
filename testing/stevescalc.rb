
require '../lib/shoes'

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
Shoes.app do

  stack do

    stack do
      number_field = edit_line(:text=>number.to_s)
    end

    stack do
      flow do
        %w(7 8 9 /).each do |btn|
          button :text=>btn do
            method = case btn
             when /[0-9]/; 'press_'+btn
             when '/'; 'press_div'
            end
            number.send(method)
            number_field.replace(number.to_s)
          end
        end
      end
      flow do
        %w(4 5 6 *).each do |btn|
          button :text=>btn do
            puts btn
            method = case btn
              
              when /[0-9]/; 'press_'+btn
              when '*'; 'press_times'
            end
            
            number.send(method)
            number_field.replace(number.to_s)
          end
        end
      end
      flow do
        %w(1 2 3 -).each do |btn|
          button :text=>btn do
            method = case btn
              when /[0-9]/; 'press_'+btn
              when '-'; 'press_sub'
            end
          
            number.send(method)
            number_field.replace(number.to_s)
          end
        end
      end
      
      flow do
        %w(Clr = +).each do |btn|
          button :text=>btn do
            method = case btn
              when 'Clr'; 'press_clear'
              when '='; 'press_equals'
              when '+'; 'press_add'
            end
            
            number.send(method)
            number_field.replace(number.to_s)
          end
        end
      end
      
    end
  end

end