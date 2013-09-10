class Shoes
  module Mock
    class EditLine
      include Shoes::Mock::CommonMethods
      attr_accessor :text, :left, :top
    end
  end
end
