require 'shoes/spec_helper'

describe Shoes::Shape do
  include_context "dsl app"

  subject { Shoes::Shape.new app, parent {} }

  it_behaves_like "object with stroke"
  #it_behaves_like "object with style"
  it_behaves_like "movable object"

  describe "octagon" do
    let(:draw) {
      Proc.new {
        xs = [200, 300, 370, 370, 300, 200, 130, 130]
        ys = [100, 100, 170, 270, 340, 340, 270, 170]
        move_to xs.first, ys.first
        xs.zip(ys).each do |x, y|
          line_to(x, y)
        end
        line_to xs.first, ys.first
      }
    }
    subject { Shoes::Shape.new app, parent, Hash.new, draw }

    its(:left) { should eq(130) }
    its(:top) { should eq(100) }
    its(:right) { should eq(370) }
    its(:bottom) { should eq(340) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"
  end

  describe "curve" do
    let(:draw) {
      Proc.new {
        move_to 10, 10
        curve_to 20, 30, 100, 200, 50, 50
      }
    }
    subject { Shoes::Shape.new app, parent, Hash.new, draw }

    its(:left)   { should eq(10) }
    its(:top)    { should eq(10) }
    its(:right)  { should eq(100) }
    its(:bottom) { should eq(200) }
    its(:width) { should eq(app.width) }
    its(:height) { should eq app.height }

    it_behaves_like "movable object"
  end
end
