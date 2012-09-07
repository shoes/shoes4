require 'shoes/spec_helper'

describe Shoes::Oval do
  let(:app_gui) { double('app gui') }
  let(:app) { double('app', gui: app_gui) }

  before :each do
    Shoes::Mock::Oval.any_instance.stub(:real) { mock( size:
      mock(x: 100, y: 100) ) }
  end

  describe "basic" do
    subject { Shoes::Oval.new(app, 20, 30, 100, 200) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "movable object"
  end

end
