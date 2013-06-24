require 'spec/shoes/spec_helper'

main_object = self

describe Shoes::Font do

  before :each do
    Shoes.configuration.stub(backend: Shoes::Mock)
    @font = Shoes::Font.new
  end

  it 'is not nil' do
    @font.should_not be_nil
  end

end
