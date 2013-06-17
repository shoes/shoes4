require 'shoes/spec_helper'

describe Shoes::Curve do
  let(:app) { Shoes::App.new }

  before :each do
  end

  describe "basic" do
    subject { Shoes::Curve.new( app, 20, 30, 100, 200, 50, 50 ) }
    it_behaves_like "object with stroke"
    it_behaves_like "movable object"

  end
end
