class Shoes
  module Swt
    # In Swt radio groups are managed by composites which occupy space 
    # and can interfere with users interacting with other controls. Here
    # we simulate radio groups so that they can all be in one composite.
    class RadioGroup
      extend Forwardable
      include Enumerable

      DEFAULT_RADIO_GROUP = "Default Radio Group"

      @group_lookup = Hash.new { |h, k| h[k] = RadioGroup.new(k) }

      attr_reader :name
      def_delegators :@radio_buttons, :each, :length, :empty?

      def initialize(name = DEFAULT_RADIO_GROUP)
        @name = name
        @radio_buttons = []
        @selection_listeners = []
      end

      def add(radio_button)
        return if @radio_buttons.include?(radio_button) 
        @radio_buttons << radio_button

        selection_listener = SelectionListener.new radio_button do |selected_radio, event|
          select_only_one_radio_in_group(selected_radio)
        end
        @selection_listeners << selection_listener
        radio_button.real.add_selection_listener selection_listener
      end

      def remove(radio_button)
        index = @radio_buttons.index(radio_button)
        return if index.nil?
        @radio_buttons.delete_at(index)

        radio_button.real.remove_selection_listener @selection_listeners[index]
        @selection_listeners.delete_at(index)
      end

      def self.group_lookup
        @group_lookup
      end

      def select_only_one_radio_in_group(selected_radio)
        @radio_buttons.each do |radio| 
          radio.real.set_selection(radio == selected_radio) 
        end
      end
    end
  end
end