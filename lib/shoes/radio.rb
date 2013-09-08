class Shoes
  class Radio < CheckButton

    # TODO according to the manual a Radio can take these options
    # :checked
    # :click
    # :group
    # :state nil|"readonly"|"disabled"
    def initialize(app, parent, opts = {}, blk = nil)
      @checked = false
      super(app, parent, opts, blk)
    end
  end
end
