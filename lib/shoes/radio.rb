class Shoes
  class Radio < CheckButton  
    attr_accessor :group

    def initialize(app, parent, group, opts = {}, blk = nil)
      @group = group
      super(app, parent, opts, blk)
    end

    def group=(value)
      self.gui.group = value
      @group = value
    end
  end
end