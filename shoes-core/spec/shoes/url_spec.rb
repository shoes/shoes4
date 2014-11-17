require 'shoes/spec_helper'

describe 'Shoes.url' do
  let(:klazz) do
    Class.new(Shoes) do
      include RSpec::Matchers

      url '/', :index
      url '/path', :path
      url '/number/(\d+)', :number
      url '/foo', :foo
      url '/visit_me', :visit_me

      def index
      end

      def path
      end

      def number(i)
      end

      def foo
        some_method
      end

      def visit_me
        expect(location).to eq '/visit_me'
      end

      def some_method
      end
    end
  end

  subject do
    Shoes.app
  end

  it "should call index upon startup" do
    expect_any_instance_of(klazz).to receive(:index)
    subject
  end

  it 'should receive path when visitting path' do
    expect_any_instance_of(klazz).to receive(:path)
    Shoes.app do visit '/path' end
  end

  it 'handles the arguments given in the regexes' do
    expect_any_instance_of(klazz).to receive(:number).with('7')
    Shoes.app do visit '/number/7' end
  end

  it 'can call methods defined in the URL class when visitting a URL' do
    expect_any_instance_of(klazz).to receive(:some_method)
    Shoes.app do visit '/foo' end
  end

  it 'has a location method that returns the current URL' do
    Shoes.app do visit('/visit_me') end
  end

  it 'instances report class as klazz (regression, do not ask...)' do
    expect(klazz.new.class).to eq klazz
  end

end
