# frozen_string_literal: true

class Shoes
  class Configuration
    class << self
      attr_accessor :app_dir
      attr_writer :fail_fast

      def fail_fast
        @fail_fast ||= ENV["SHOES_FAIL_FAST"]
      end

      def backend
        @backend ||= Shoes.load_backend(backend_name)
      end

      def backend_name
        @backend_name ||= ENV.fetch('SHOES_BACKEND', default_backend).to_sym
      end

      def default_backend
        if caller.any? { |path| path =~ /rspec/ }
          :mock
        else
          :swt
        end
      end

      # Set the Shoes backend to use. Can only be set once. Note the backend is
      # not required during this method, but rather when
      # `Shoes::Configuration#backend` is called.
      #
      # @param [Symbol] name The backend's name
      # @raise [RuntimeError] If backend has already been set.
      # @see Shoes::Configuration#backend
      # @example
      #   Shoes::Configuration.backend = :swt
      def backend=(name)
        return if @backend_name == name

        unless @backend.nil?
          raise "Can't switch backend to Shoes::#{name.capitalize}, Shoes::#{backend_name.capitalize} backend already loaded."
        end
        @backend_name ||= name
      end

      # Finds the appropriate backend class for the given Shoes object or class
      #
      # @param [Object] object A Shoes object or a class
      # @return [Object] An appropriate backend class
      # @example
      #   Shoes.configuration.backend_class(shoes_button) # => Shoes::Swt::Button
      def backend_class(object)
        klazz = object.is_a?(Class) ? object : find_shoes_base_class(object)
        class_name = klazz.name.split("::").last
        # Lookup with false to not consult modules higher in the chain Object
        # because Shoes::Swt.const_defined? 'Range' => true
        raise ArgumentError, "#{object} does not have a backend class defined for #{backend}" unless backend.const_defined?(class_name, false)
        backend.const_get(class_name, false)
      end

      def find_shoes_base_class(object)
        return object.shoes_base_class if object.respond_to?(:shoes_base_class)
        object.class
      end

      # Creates an appropriate backend object, passing along additional
      # arguments
      #
      # @param [Object] shoes_object A Shoes object
      # @return [Object] An appropriate backend object
      #
      # @example
      #   Shoes.backend_for(button, args) # => <Shoes::Swt::Button:0x12345678>
      def backend_for(shoes_object, *args, &blk)
        # Some element types (packager for instance) legitimately don't have
        # an app. In those cases, don't try to get it to pass along.
        args.unshift(shoes_object.app.gui) if shoes_object.respond_to?(:app)
        backend_factory(shoes_object).call(shoes_object, *args, &blk)
      end

      def backend_factory(shoes_object)
        klass = backend_class(shoes_object)
        klass.respond_to?(:create) ? klass.method(:create) : klass.method(:new)
      end
    end
  end
end

def Shoes.configuration
  Shoes::Configuration
end

def Shoes.backend_for(shoes_object, *args, &blk)
  Shoes::Configuration.backend_for(shoes_object, *args, &blk)
end

def Shoes.backend
  Shoes.configuration.backend
end
