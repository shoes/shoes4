require 'shoes/spec_helper'

describe 'Shoes.url' do
  let(:klazz) do
    Class.new(Shoes) do
      url '/', :index
      url '/path', :path
      url '/number/(\d+)', :number
      url '/foo', :foo

      def index
      end

      def path
      end

      def number(i)
      end

      def foo
        some_method
      end

      def some_method
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

  it 'should receive path when visitting path' do
    klazz.any_instance.should_receive(:path)
    Shoes.app do visit '/path' end
  end

  it 'handles the arguments given in the regexes' do
    klazz.any_instance.should_receive(:number).with('7')
    Shoes.app do visit '/number/7' end
  end

  it 'can call methods defined in the URL class when visitting a URL' do
    klazz.any_instance.should_receive(:some_method)
    Shoes.app do visit '/foo' end
  end

end
