class Shoes
  module Mock
    class EditLine
      include Shoes::Mock::CommonMethods
      attr_accessor :text
    end
  end
end
