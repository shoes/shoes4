class Shoes
  module Swt
    # In Swt radio groups are managed by composites which occupy space 
    # and can interfere with users interacting with other controls. Here
    # we simulate radio groups so that they can all be in one composite.
    class RadioGroup
      DEFAULT_RADIO_GROUP = "Default Radio Group"

      attr_reader :name

      def initialize(name = DEFAULT_RADIO_GROUP)
        @name = name
        @radio_buttons = []
        @selection_listeners = []
      end

      def add(radio_button)
        return if @radio_buttons.include?(radio_button) 
        @radio_buttons << radio_button
        selection_listener = SelectionListener2.new radio_button do |selected_radio, event|
          select_one_radio_in_group(selected_radio)
        end
        @selection_listeners << selection_listener
        radio_button.real.add_selection_listener selection_listener
      end

      def remove(radio_button)
        index = @radio_buttons.index(radio_button)
        return if index.nil?
        @radio_buttons.delete_at(index)
        radio_button.real.remove_selection_listener @selection_listeners[index]
        @selection_listeners.delete(index)
      end

      private

      def select_one_radio_in_group(selected_radio)
          @radio_buttons.each do |radio| 
            radio.real.set_selection(radio == selected_radio) 
          end
      end
    end

    class SelectionListener2

      def initialize radio, &blk
        @radio = radio
        @blk = blk
      end
      def widget_selected event
        @blk.call @radio, event
      end
    end


=begin
    class SelectionListener2
      def initialize radio, all_radios
        @radio = radio
        @all_radios = all_radios
      end
      def widget_selected e
        @all_radios.each do |radio| 
          radio.real.set_selection(radio == @radio) 
        end
        puts "Got selected radio: #{@radio.real.get_selection}, Has focus: #{@radio.real.is_focus_control}"
      end
    end
    class KeyListener2
      def keyPressed(e)
        puts "KeyPressed"
        e.doit = false
      end
      def keyReleased(e)
        puts "KeyReleased"
        e.doit = false
      end
    end

    class TraverseListener
      def initialize
        puts "Traverse initialize"
      end

      def keyTraversed(event)
        puts "Traverse Key Event: #{event}"
        event.doit = false if event.detail == ::Swt::SWT::TRAVERSE_ARROW_NEXT
      end
    end
=end

  end
end