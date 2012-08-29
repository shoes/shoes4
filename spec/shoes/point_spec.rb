describe Shoes::Point do
  subject { Shoes::Point.new(40, 50) }

  its(:x) { should eq(40) }
  its(:y) { should eq(50) }
end
