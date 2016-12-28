require 'rbconfig'

class Shoes
  module SelectedBackend
    class << self
      def generate(path)
        options = "-J-XstartOnFirstThread" if RbConfig::CONFIG["host_os"] =~ /darwin/

        "jruby #{options} #{path}/shoes-swt"
      end
    end
  end
end
