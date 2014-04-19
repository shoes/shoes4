class Shoes
  module Swt
    module DisposedProtection
      def mark_for_disposal(resource_objects)
        ObjectSpace.define_finalizer(self, self.class.finalize(resource_objects))
      end

      def self.included(mod)
        mod.extend ClassMethods
      end

      module ClassMethods
        def finalize(resource_objects)
          Proc.new do
            Array(resource_objects).each do |resource|
              puts "#{Time.now.strftime("[%H:%M:%S:%L]")} Disposing #{resource.inspect}"
              resource.dispose unless resource.disposed?
            end
          end
        end
      end

      def real
        return NullObject.new(@real) if @real.disposed?
        @real
      end

      class NullObject < BasicObject
        def initialize(real)
          @real = real
        end

        def respond_to?(method)
          @real.respond_to? method
        end

        def method_missing(method, *args)
        end
      end
    end
  end
end
