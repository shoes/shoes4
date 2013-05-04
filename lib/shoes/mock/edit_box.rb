module Shoes
  module Mock
    class EditBox
      include Shoes::Mock::CommonMethods
      attr_accessor :text
    end
  end
end
