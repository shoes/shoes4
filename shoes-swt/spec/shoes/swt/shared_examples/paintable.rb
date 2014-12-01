shared_examples_for "paintable" do
  it "registers for painting" do
    expect(swt_app).to receive(:add_paint_listener)
    subject
  end
end

