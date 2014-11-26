require 'benchmark'
require File.dirname(__FILE__) + '/para_creator'

Shoes.app do
  extend ParaCreator

  # no this code does not make any sense, it just piles up a lot of objects
  # onto the application
  # paras are commented out due to #322
  def fill_up_app_with_senseless_stuff
    stack do
      #create_paras 4
      #flow do create_paras 2 end
      oval 0, 0, 20, 20, fill: forestgreen, stroke: nil
      rect 0, 0, 75, 4, curve: 3
      rect 0, 396, 75, 4, curve: 3
    end
    stack do
      path = File.join(Shoes::DIR, 'static/shoes-icon.png')
      image path
      flow do
        15.times do
          edit_line
        end
        50.times do
          flow do
            image path
            image path
          end
        end
        stack do
          star 56, 77
        end
      end
      stack do
        image path
        #para ' ' * 20 + 'Powered by JRuby and SWT!'
        24.times do
          flow do
            #create_paras 12
            button 'Hello I am a button!' do alert 'hi you all' end
          end
        end
      end
      stack do
        30.times do
          rect 400, 596, 75, 30,fill: green
          rect 500, 696, 75, 30,fill: red
          rect 600, 796, 75, 30,fill: blue
        end
      end
    end
  end

  button 'start repeated clear benchmark' do
    Benchmark.bm do |benchmark|
      3.times do |i|
        benchmark.report "#{i + 1}. fill app" do
          fill_up_app_with_senseless_stuff
        end

        benchmark.report "#{i + 1}. clear app" do
          clear
        end
      end
    end
  end

end
