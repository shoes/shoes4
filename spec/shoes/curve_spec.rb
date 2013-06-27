require 'shoes/spec_helper'

describe Shoes::Curve do
  let(:app) { Shoes::App.new }

  before :each do
  end

  describe "basic" do
    subject { Shoes::Curve.new( app, Shoes::Point.new(10, 10), Shoes::Point.new(20, 30), Shoes::Point.new(100, 200), Shoes::Point.new(50, 50) ) }

    it_behaves_like "object with stroke"
    it_behaves_like "movable object"

    its(:left)   { should eq(10) }
    its(:top)    { should eq(10) }
    its(:width)  { should eq(90) }
    its(:height) { should eq(190) }
  end
end
