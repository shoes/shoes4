shared_examples_for "toggable" do
  it "triggers redrawing on the app" do
    container.should_receive(:redraw)
    subject.toggle
  end
end
