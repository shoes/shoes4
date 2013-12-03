shared_examples "movable element" do |left, top|

  before :each do
    dsl.stub element_left: left, element_top: top
  end

  context "with disposed real element" do
    before :each do
      real.stub(:disposed?) { true }
    end

    it "doesn't delegate to real" do
      real.should_not_receive(:set_location)
      subject.update_position
    end
  end

  context "with undisposed real element" do
    before :each do
      real.stub(:disposed?) { false }
    end

    it "delegates to real" do
      real.should_receive(:set_location).with(left, top)
      subject.update_position
    end
  end
end

shared_examples_for "movable shape" do |x, y|
  it "redraws container" do
    container.should_receive(:redraw).at_least(2).times
    dsl.stub element_left: x, element_top: y
    subject.update_position
  end
end

shared_examples_for "movable text" do |x, y|
  it "redraws container" do
    swt_app.should_receive(:redraw).at_least(1).times
    dsl.stub element_left: x, element_top: y
    subject.update_position
  end
end
