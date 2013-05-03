module Shoes
  module URL
    class << self
      attr_accessor :shoes_included_instance

      def urls
        @urls ||= {}
      end
    end

    def self.included klass
      Shoes::URL.shoes_included_instance = klass.new

      # @param page   [String]        The url pattern
      # @param method [Symbol|String] The method name
      def klass.url page, method
        klass = self
        page = /^#{page}$/

        Shoes::URL.urls[page] = proc do |app, arg|

          klass.class_eval do
            define_method :method_missing do |method, *args, &blk|
              app.send method, *args, &blk
            end
          end

          arg ? klass.new.send(method, arg) : klass.new.send(method)
        end
      end
    end
  end

  def self.included(base)
    base.instance_eval do
      include URL
    end
  end
end
