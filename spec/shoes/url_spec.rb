require 'shoes/spec_helper'

describe 'Shoes.url' do
  let(:klazz) do
    Class.new(Shoes) do
      url '/', :index
      url '/path', :path

      def index
      end

      def visit_path
        visit '/path'
      end

      def path
      end
    end
  end

  subject do
    Shoes.app
  end

  it "should call index upon startup" do
    klazz.any_instance.should_receive(:index)
    subject
  end

end
