module Shoes
  module Package
    class P
      def initialize(backend, wrapper)
        @backend, @wrapper = backend, wrapper
      end

      def package
        puts "Packaging as #{@backend}:#{@wrapper}"
      end
    end
    def self.new(backend, wrapper, config)
      # Belongs in Shoes::Configuration
      require "shoes/#{backend.to_s.downcase}"
      backend_class_name = backend.to_s.capitalize
      wrapper_class_name = wrapper.to_s.capitalize
      klass = [backend_class_name, 'Package', wrapper_class_name].inject(Shoes) do |klass, const|
        klass.const_get(const)
      end
      klass.new config
    rescue LoadError => e
      raise LoadError, "Couldn't load backend '#{backend}'. Error: #{e.message}\n#{e.backtrace.join("\n")}"
      P.new(backend, wrapper)
    end
  end
end
