class Shoes
  class Radio < CheckButton
    style_with :checked, :click, :common_styles, :dimensions, :group, :state

    def initialize(app, parent, group, styles = {}, blk = nil)
      styles[:group] = group
      super(app, parent, styles, blk)
    end

    def group=(value)
      style(group: value)
      gui.group = value
    end
  end
end
