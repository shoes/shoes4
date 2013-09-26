require 'shoes/spec_helper'

describe Shoes::Oval do
  let(:app) { Shoes::App.new }

  describe "basic" do
    subject { Shoes::Oval.new(app, 20, 30, 100, 200) }
    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"
    it_behaves_like "movable object"
  end

  context "center" do
    subject { Shoes::Oval.new(app, 100, 50, 40, 20, :center => true) }

    its(:left) { should eq(80) }
    its(:top) { should eq(40) }
    its(:right) { should eq(120) }
    its(:bottom) { should eq(60) }
    its(:width) { should eq(40) }
    its(:height) { should eq(20) }
  end

end
