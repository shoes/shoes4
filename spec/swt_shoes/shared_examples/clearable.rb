shared_examples_for "clearable" do
  it "should respond to clear" do
    subject.should respond_to :clear
  end

  it "should remove paint listener" do
    swt_app.should_receive(:remove_paint_listener)
    swt_app.should_receive(:remove_listener).at_least(2).times
    subject.clear
  end

  it "clears color factory if present" do
    swt_app.as_null_object

    color_factory = double("color factory")
    expect(color_factory).to receive(:dispose)
    subject.instance_variable_set(:@color_factory, color_factory)

    subject.clear
  end
end

shared_examples_for "clearable native element" do
  it "should respond to clear" do
    subject.should respond_to :clear
  end

  it "should dispose real when real is not disposed" do
    swt_app.stub(:remove_listener)
    real.stub(:disposed?) { false }
    real.should_receive(:dispose)
    subject.clear
  end

  it "should not dispose real when real is already disposed" do
    swt_app.stub(:remove_listener)
    real.stub(:disposed?) { true }
    real.should_not_receive(:dispose)
    subject.clear
  end
end

