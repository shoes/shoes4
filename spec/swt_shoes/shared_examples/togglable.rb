shared_examples_for "togglable" do
  it "triggers redrawing on the app" do
    container.should_receive(:redraw)
    subject.toggle
  end

  it "passes visibility to real object" do
    if subject.respond_to?(:gui) && subject.gui.respond_to?(:real)
      subject.gui.real.should_receive(:set_visible)
      subject.toggle
    end
  end
end
