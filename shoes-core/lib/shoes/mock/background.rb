# frozen_string_literal: true

class Shoes
  module Mock
    class Background
      include Shoes::Mock::CommonMethods

      def background=(*_opts)
      end
    end
  end
end
