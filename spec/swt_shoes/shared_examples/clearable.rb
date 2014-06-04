shared_examples_for "clearable" do
  it "should respond to clear" do
    expect(subject).to respond_to :clear
  end

  it "should remove paint listener" do
    expect(swt_app).to receive(:remove_paint_listener)
    expect(swt_app).to receive(:remove_listener).at_least(2).times
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
    expect(subject).to respond_to :clear
  end

  it "should dispose real when real is not disposed" do
    allow(swt_app).to receive(:remove_listener)
    allow(real).to receive(:disposed?) { false }
    expect(real).to receive(:dispose)
    subject.clear
  end

  it "should not dispose real when real is already disposed" do
    allow(swt_app).to receive(:remove_listener)
    allow(real).to receive(:disposed?) { true }
    expect(real).not_to receive(:dispose)
    subject.clear
  end
end

