require 'swt'
require 'shoes/swt'

$callers = {}

classes = [
  ::Swt::Graphics::Color,
  ::Swt::Graphics::Font,
  ::Swt::TextLayout,
]

classes.each do |klass|
  klass.class_eval do
    define_singleton_method(:new) do |*args|
      key = "[#{self.name}]\n" + caller.join("\n\t")
      $callers[key] ||= 0
      $callers[key] += 1

      result = super(*args)
      result.instance_variable_set(:@__shoes_creation_backtrace, key)
      result
    end

    define_method(:dispose) do |*args|
      $callers[@__shoes_creation_backtrace] -= 1
      super(*args)
    end
  end
end

at_exit do
  $callers.each do |k, v|
    if v > 0
      puts "#{v} => #{k}"
      puts
    end
  end
end
