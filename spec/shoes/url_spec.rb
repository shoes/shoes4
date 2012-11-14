require 'shoes/spec_helper'

describe 'Shoes.url' do
  subject do
    class Hello
      include Shoes
      url '/', :index
      def index; end
    end
    Shoes.app
  end

  it "should have $urls" do
    $urls.should be_empty
    subject
    $urls.should_not be_empty
  end
end
