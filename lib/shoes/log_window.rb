class Shoes
  class LogWindow
    def self.setup(app)
      Shoes.app do
        app.stack do
          app.flow do
            app.background app.black
            app.stack do
              app.tagline "Shoes Console", :stroke => app.white
            end
            app.button "Clear", :margin => 6, :width => 80, :height => 40 do
            end
          end
          @log, @hash = app.stack, nil
          puts Shoes::LOG
#          update_console
          #app.every(0.2) do
          #  Shoes::LogWindow.update
          #end
        end
      end
    end

    def update_console
      @log.clear do
        i = 0
        Shoes::LOG.each do |typ, msg|
          para typ, :stroke => blue
          stack do
            background "#f1f5e1" if i % 2 == 0
            para typ, stroke: "#05C"
            inscription strong(typ.capitalize, :stroke => "#05C"), " in "
            flow do
              stack :margin => 4 do
                s = msg.to_s
                para s, :margin => 4, :margin_top => 0
              end
            end
          end
          i += 1
        end
      end
    end
  end
end

