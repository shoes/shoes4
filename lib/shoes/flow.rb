require 'facets/hash'

module Shoes
  class Flow

    include Shoes::ElementMethods
    
    attr_accessor :parent_container, :parent_gui_container, :gui_container
    attr_accessor :blk
    attr_accessor :width, :height, :margin


    def initialize(parent_container, parent_gui_container, opts={}, blk = nil)
      self.parent_container = parent_container
      self.parent_gui_container = parent_gui_container
      opts.stringify_keys!

      self.width = opts['width']
      self.height = opts['height']
      self.margin = opts['margin']

      self.blk = blk

      gui_flow_init

      instance_eval &blk unless blk.nil?

      gui_flow_add_to_parent

    end
  end
end