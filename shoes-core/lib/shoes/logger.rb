class Shoes
  module Logger
    class << self
      def register(name, obj)
        @loggers ||= {}
        @loggers[name] = obj
      end

      def unregister(name)
        @loggers.delete(name)
      end

      def get(name)
        @loggers && @loggers[name]
      end
    end

    def self.setup
      Shoes.app do
        def update
          return unless @hash == Shoes::LOG.hash
          @hash = Shoes::LOG.hash
          @log.clear do
            Shoes::LOG.each_with_index do |(typ, msg), index|
              stack do
                background "#f1f5e1" if index.even?
                background rgb(220, 220, 220) if index.odd?
                para typ, stroke: blue
                flow do
                  stack margin: 4 do
                    s = msg.to_s
                    para s, margin: 4, margin_top: 0
                  end
                end
              end
            end
          end
        end

        stack do
          flow do
            background black
            stack do
              tagline "Shoes Console", stroke: white
            end
            button "Clear", margin: 6, width: 80, height: 40, right: 10 do
              Shoes::LOG.clear
            end
          end
          @log, @hash = stack, nil
          update

          every(0.2) do
            update
          end
        end
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), "logger", "*.rb")].each do |logger|
  require logger
end
