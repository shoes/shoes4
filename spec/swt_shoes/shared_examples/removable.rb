shared_examples_for "removable" do
  it "should respond to remove" do
    expect(subject).to respond_to :remove
  end

  it "should remove paint listener" do
    expect(swt_app).to receive(:remove_paint_listener)
    expect(swt_app).to receive(:remove_listener).at_least(2).times
    subject.remove
  end

  it "disposes color factory if present" do
    swt_app.as_null_object

    color_factory = double("color factory")
    expect(color_factory).to receive(:dispose)
    subject.instance_variable_set(:@color_factory, color_factory)

    subject.remove
  end
end

shared_examples_for "removable native element" do
  it "should respond to remove" do
    expect(subject).to respond_to :remove
  end

  it "should dispose real when real is not disposed" do
    allow(swt_app).to receive(:remove_listener)
    allow(real).to receive(:disposed?) { false }
    expect(real).to receive(:dispose)
    subject.remove
  end

  it "should not dispose real when real is already disposed" do
    allow(swt_app).to receive(:remove_listener)
    allow(real).to receive(:disposed?) { true }
    expect(real).not_to receive(:dispose)
    subject.remove
  end
end
