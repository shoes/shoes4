$:<< '../lib'

require 'rspec'

require 'pry'
require 'shoes'

Dir["./spec/support/**/*.rb"].each {|f| require f}

# Guards for running or not running specs. Specs in the guarded block only
# run if the guard conditions are met.
#
# @see Guard#backend_is
module Guard
  # Runs specs only if backend matches given name
  #
  # @example
  # backend_is :swt do
  #   specify "backend_name is :swt" do
  #     # body of spec
  #   end
  # end
  def backend_is(backend)
    yield if Shoes.configuration.backend_name == backend && block_given?
  end
end

include Guard

