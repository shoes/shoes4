shared_examples_for "clearable" do
  it "should respond to clear" do
    subject.should respond_to :clear
  end

  it "should redraw and remove paint listener" do
    container.should_receive(:disposed?)
    container.should_receive(:redraw)
    container.should_receive(:remove_paint_listener)
    subject.clear
  end
end

