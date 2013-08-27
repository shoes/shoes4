class Shoes
  class FakeElement
    include CommonMethods
    attr_reader :height, :width
    attr_accessor :top, :left
    def initialize(opts)
      @height = opts[:height]
      @width = opts[:width]
      @top = opts[:left] || 0
      @left = opts[:top] || 0
    end
  end
end