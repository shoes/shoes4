require 'delegate'

class Shoes
  module Logger
    class Ruby < SimpleDelegator
      def initialize
        require 'logger'
        super(::Logger.new(STDOUT))
      end
    end
  end
end

Shoes::Logger.register(:ruby, Shoes::Logger::Ruby)
