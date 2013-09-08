class Shoes
  class EditLine < InputBox
    DEFAULT_STYLE = { width:  200,
                      height: 28 }

    def initialize(app, parent, text, opts={}, blk = nil)
      super(app, parent, text, DEFAULT_STYLE.merge(opts), blk)
    end
  end
end
