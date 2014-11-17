shared_examples "buttons" do

  it "calls set_focus when focus is called" do
    expect(real).to receive(:set_focus)
    subject.focus
  end

end

# Check and Radio
shared_examples "selectable" do
  it "calls get_selection when checked? is called" do
    expect(real).to receive(:get_selection)
    subject.checked?
  end

  it "calls set_selection when checked= is called" do
    expect(real).to receive(:set_selection).with(true)
    subject.checked = true
  end
end
