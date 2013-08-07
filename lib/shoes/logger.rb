class Shoes
  module Logger
    class << self

      def register(name, obj)
        @loggers ||= { }
        @loggers[name] = obj
      end

      def unregister(name)
        @loggers.delete(name)
      end

      def get(name)
        @loggers && @loggers[name]
      end
    end

    def self.setup(app)
      Shoes.app do
        def update
          if @hash != Shoes::LOG.hash
            @hash = Shoes::LOG.hash
            @log.clear do
              i = 0
              Shoes::LOG.each do |typ, msg|
                stack do
                  background "#f1f5e1" if i % 2 == 0
                  background rgb(220, 220, 220) if i % 2 != 0
                  para typ, :stroke => blue
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

        stack do
          flow do
            background app.black
            stack do
              tagline "Shoes Console", stroke: white
            end
            button "Clear", margin: 6, width: 80, height: 40, right: 10 do
              Shoes::LOG.clear
            end
          end
          @log, @hash = stack, nil
          update

          app.every(0.2) do
            update
          end
        end
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "logger", "*.rb")].each { |logger|
  require logger
}
