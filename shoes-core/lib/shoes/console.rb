# frozen_string_literal: true
class Shoes
  class Console
    def initialize
      @messages = []
    end

    def show
      if showing?
        @app.focus
      else
        create_app
      end
    end

    def showing?
      @app && @app.open?
    end

    def create_app
      # Capture messages for access inside our app block
      messages = @messages
      formatted_messages = method(:formatted_messages)

      @app = Shoes.app do
        @messages = messages
        @message_stacks = []
        @formatted_messages = formatted_messages

        stack do
          flow do
            background black
            stack do
              tagline "Shoes Console", stroke: white
            end

            button "Copy", margin: 6, width: 80, height: 40, right: 170 do
              self.clipboard = @formatted_messages.call if @messages.length > 0
            end

            button "Save", margin: 6, width: 80, height: 40, right: 90 do
              filename = ask_save_file

              if filename
                File.open(filename, "w") do |f|
                  f.write(@formatted_messages.call)
                end
              end
            end

            button "Clear", margin: 6, width: 80, height: 40, right: 10 do
              @messages.clear

              @message_stacks.each(&:remove)
              @message_stacks.clear
            end
          end
        end
      end

      @messages.each_with_index do |(type, message), index|
        add_message_stack(type, message, index)
      end
    end

    def debug(message)
      add_message(:debug, message)
    end

    def info(message)
      add_message(:info, message)
    end

    def warn(message)
      add_message(:warn, message)
    end

    def error(message)
      add_message(:error, message)
    end

    def add_message(type, message)
      @messages << [type, message]
      add_message_stack(type, message, @messages.count - 1)
    end

    def add_message_stack(type, message, index = nil)
      return unless @app && @app.open?

      @app.instance_exec do
        append do
          @message_stacks << stack do
            background "#f1f5e1" if index.even?
            background rgb(220, 220, 220) if index.odd?
            para type, stroke: blue
            flow do
              stack margin: 4 do
                s = message.to_s
                para s, margin: 4, margin_top: 0
              end
            end
          end
        end
      end
    end

    def formatted_messages
      @messages.inject("") do |memo, (type, message)|
         "#{memo}#{type.to_s.capitalize}\n #{message}\n\n"
      end
    end
  end
end
