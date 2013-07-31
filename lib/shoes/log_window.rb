class Shoes
  class LogWindow
    def self.setup(app)
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
        #update
        app.every(0.2) do
          #update
        end
      end
    end

    def self.update
      if @hash != Shoes::LOG.hash
        # Shoes3 code that I don't understand yet - Faraaz
        #@hash = Shoes::LOG.hash
        @log.clear do
          i = 0
          Shoes::LOG.each do |typ, msg|
            stack do
              background "#f1f5e1" if i % 2 == 0
              inscription strong(typ.to_s.capitalize, :stroke => "#05C"), " in "
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
end

Shoes.app do
  Shoes::LogWindow.setup(app)
end
