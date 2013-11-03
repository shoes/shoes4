shared_examples_for "togglable" do
  it "triggers redrawing on the app" do
    container.should_receive(:redraw)
    subject.toggle
  end
end
