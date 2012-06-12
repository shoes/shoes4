module Shoes
  class Flow

    include Shoes::ElementMethods
    
    attr_accessor :parent_container, :parent_gui_container, :gui
    attr_accessor :blk
    attr_accessor :width, :height, :margin


    def initialize(parent_container, parent_gui_container, opts={}, blk = nil)
      puts "parent_container: #{parent_container}"
      puts "parent.gui_container: #{parent_gui_container}"
      self.parent_container = parent_container
      self.parent_gui_container = parent_gui_container

      self.width = opts[:width]
      self.height = opts[:height]
      self.margin = opts[:margin]
      @app = opts[:app]

      self.blk = blk

      gui_flow_init

      instance_eval &blk unless blk.nil?

      gui_flow_add_to_parent

    end
  end
end
