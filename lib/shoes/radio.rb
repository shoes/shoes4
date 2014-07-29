class Shoes
  class Radio < CheckButton
    
    style_with :group

    def initialize(app, parent, group, styles = {}, blk = nil)
      super(app, parent, styles, blk)
      style_init(styles, group: group)
    end

    def group=(value)
      @style[:group] = value
      self.gui.group = value
    end
  end
end
