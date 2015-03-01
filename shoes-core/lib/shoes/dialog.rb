class Shoes
  class Dialog
    def initialize
      @gui = Shoes.backend::Dialog.new
    end

    def alert(msg = '')
      @gui.alert msg
    end

    def confirm(msg = '')
      @gui.confirm msg
    end

    def dialog_chooser(title, folder = false, style = :open)
      @gui.dialog_chooser title, folder, style
    end

    def ask(msg, args)
      ask_me = Shoes.app(title: args[:title] || "Shoes asks:",
                         width: 300, height: 125,
                         modal: true) do
        stack do
          para msg, margin: 10

          @e = edit_line margin_left: 10,
                         width:       width - 20,
                         secret:      args[:secret]

          flow margin_top: 10 do
            button "OK", margin_left: 150 do
              @result = @e.text
              quit
            end

            button "Cancel" do
              @result = nil
              quit
            end
          end
        end

        def result
          @result
        end
      end

      ask_me.wait_until_closed
      ask_me.result
    end

    def ask_color(title)
      @gui.ask_color title
    end
  end
end
