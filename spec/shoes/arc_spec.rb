describe Shoes::Arc do
  subject { Shoes::Arc.new }

  it "is a Shoes::Arc" do
    subject.class.should be(Shoes::Arc)
  end
end
