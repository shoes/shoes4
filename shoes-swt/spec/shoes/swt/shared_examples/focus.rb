# frozen_string_literal: true
shared_examples "focusable" do
  it "calls set_focus when focus is called" do
    expect(real).to receive(:set_focus)
    subject.focus
  end

  it "calls has_focus when focused? is called" do
    expect(real).to receive(:has_focus)
    subject.focused?
  end

  it "has a method #focused which is an alias for #focused?" do
    expect(subject.method(:focused) == subject.method(:focused?)).to be true
  end

  it "has a method #focussed which is an alias for #focused?" do
    expect(subject.method(:focussed) == subject.method(:focused?)).to be true
  end

  it "has a method #focussed? which is an alias for #focused?" do
    expect(subject.method(:focussed?) == subject.method(:focused?)).to be true
  end
end
