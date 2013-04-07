shared_context "with a mock dsl object" do
  let(:dsl) do
    Class.new do
      include Shoes::ElementMethods
      include RSpec::Mocks::ExampleMethods

      def initialize
        @current_slot = double('current_slot').as_null_object
        @gui = double('current_slot').as_null_object
      end

    end.new
  end
end
