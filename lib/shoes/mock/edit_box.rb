module Shoes
  module Mock
    class EditBox
      attr_accessor :text
      include Shoes::Mock::CommonMethods
    end
  end
end
