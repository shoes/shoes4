require 'shoes/spec_helper'

describe Shoes::Shape do
  it_behaves_like "object with stroke"
  it_behaves_like "object with style"
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
    subject { Shoes::Shape.new Hash.new, draw }

    its(:left) { should eq(130) }
    its(:top) { should eq(100) }
    its(:right) { should eq(370) }
    its(:bottom) { should eq(340) }
    its(:width) { should eq(240) }
    its(:height) { should eq(240) }

    it_behaves_like "movable object"
  end
end
