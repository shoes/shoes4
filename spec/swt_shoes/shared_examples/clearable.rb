shared_examples_for "clearable" do
  it "should respond to clear" do
    subject.should respond_to :clear
  end

  it "should remove paint listener" do
    subject.app.should_receive(:remove_paint_listener)
    subject.app.should_receive(:remove_listener).at_least(2).times
    subject.clear
  end
end

shared_examples_for "clearable native element" do
  it "should respond to clear" do
    subject.should respond_to :clear
  end

  it "should dispose real when real is not disposed" do
    subject.app.stub(:remove_listener)
    real.stub(:disposed?) { false }
    real.should_receive(:dispose)
    subject.clear
  end

  it "should not dispose real when real is already disposed" do
    subject.app.stub(:remove_listener)
    real.stub(:disposed?) { true }
    real.should_not_receive(:dispose)
    subject.clear
  end
end

