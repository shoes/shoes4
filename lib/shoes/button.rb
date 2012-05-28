require 'shoes/common_methods'

module Shoes
  class Button
    include Shoes::CommonMethods

    attr_accessor :gui_container, :click_event_lambda
    attr_accessor :gui_element
    attr_accessor :text

    def initialize(gui_container, text = 'Button', opts={}, click_event_lambda = nil)
      self.gui_container = gui_container
      self.click_event_lambda = click_event_lambda
      self.text = text
      @app = opts[:app]
      @height = opts[:height]
      @width = opts[:width]

      gui_button_init
    end

  end
end
