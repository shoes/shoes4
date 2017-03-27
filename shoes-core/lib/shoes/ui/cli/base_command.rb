# frozen_string_literal: true
class Shoes
  module UI
    class CLI
      class BaseCommand
        attr_reader :args

        def initialize(args)
          @args = args
        end
      end
    end
  end
end
