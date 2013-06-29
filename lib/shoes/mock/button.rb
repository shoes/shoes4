class Shoes
  module Mock
    class Button
      include Shoes::Mock::CommonMethods

      attr_accessor :width, :height
    end
  end
end
