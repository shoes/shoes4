shared_examples_for "updating visibility" do
  it "triggers redrawing on the app" do
    with_redraws do
      expect(swt_app).to receive(:redraw)
      subject.update_visibility
    end
  end

  it "passes visibility to real object" do
    if subject.respond_to?(:gui) && subject.gui.respond_to?(:real)
      expect(subject.gui.real).to receive(:set_visible)
      subject.update_visibility
    end
  end
end
