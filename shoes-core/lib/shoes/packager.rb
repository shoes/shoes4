class Shoes
  class Packager
    attr_reader :packages, :backend

    def initialize
      begin
        @backend = Shoes.backend_for(self)
      rescue ArgumentError
        # Packaging unsupported by this backend
      end
      @packages = []
    end

    def create_package(program_name, package)
      @packages << @backend.create_package(program_name, package)
    end

    def should_package?
      @packages.any?
    end

    def run(path)
      raise "Packaging unsupported by this backend" if @backend.nil?
      @backend.run(path)
    end

    def help(program_name)
      return "" if @backend.nil?
      @backend.help(program_name)
    end
  end
end
