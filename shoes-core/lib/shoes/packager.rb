class Shoes
  class Packager
    attr_reader :packages, :backend

    def initialize
      @backend = Shoes.configuration.backend_for(self)
      @packages = []
    end

    def create_package(program_name, package)
      @packages << @backend.create_package(program_name, package)
    end

    def should_package?
      @packages.any?
    end

    def run(path)
      @backend.run(path)
    end

    def help(program_name)
      @backend.help(program_name)
    end
  end
end
