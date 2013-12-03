shared_examples_for "togglable" do
  it "triggers redrawing on the app" do
    if defined? paint_container
      container = paint_container
    elsif defined? swt_app
      container = swt_app
    end
    expect(container).to receive(:redraw).at_least(:once)
    subject.toggle
  end

  it "passes visibility to real object" do
    if subject.respond_to?(:gui) && subject.gui.respond_to?(:real)
      expect(subject.gui.real).to receive(:set_visible)
      subject.toggle
    end
  end
end
