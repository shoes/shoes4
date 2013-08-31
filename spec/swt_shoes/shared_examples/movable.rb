shared_examples "movable element" do |left, top|
  context "with disposed real element" do
    before :each do
      real.stub(:disposed?) { true }
    end

    it "doesn't delegate to real" do
      real.should_not_receive(:set_location)
      subject.move left, top
    end
  end

  context "with undisposed real element" do
    before :each do
      real.stub(:disposed?) { false }
    end

    it "delegates to real" do
      real.should_receive(:set_location).with(left, top)
      subject.move left, top
    end
  end
end

shared_examples_for "movable shape" do |x, y|
  it "redraws container" do
    container.should_receive(:redraw).at_least(2).times
    subject.move x, y
  end

  it "moves" do
    container.stub(:redraw)
    subject.move x, y
    subject.left.should eq(x)
    subject.top.should eq(y)
  end
end

shared_examples_for "movable text" do |x, y|
  it "redraws container" do
    container.should_receive(:redraw).at_least(1).times
    subject.move x, y
  end

  it "moves" do
    container.stub(:redraw)
    subject.move x, y
    subject.instance_variable_get("@left").should eq(x)
    subject.instance_variable_get("@top").should eq(y)
  end
end
