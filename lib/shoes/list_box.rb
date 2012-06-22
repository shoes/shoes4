require 'shoes/common_methods'

module Shoes
  class List_box
    include Shoes::CommonMethods

    attr_accessor :parent, :gui_element
    attr_reader :items

    def initialize(parent, opts = {}, blk = nil)
      self.parent = parent
      @blk = blk
      @app = opts[:app]

      gui_list_box_init
      self.items = opts.has_key?(:items) ? opts[:items] : [""]
    end

    def items=(values)
      @items = values
      gui_update_items values
    end
  end
end
