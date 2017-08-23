# frozen_string_literal: true
shared_examples "focusable" do
  it "calls set_focus when focus is called" do
    expect(real).to receive(:set_focus)
    subject.focus
  end
end
