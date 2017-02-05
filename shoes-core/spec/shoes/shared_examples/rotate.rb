# frozen_string_literal: true
shared_examples "object with rotate" do
  it "doesn't rotate on nil" do
    subject.rotate = nil
    expect(subject.needs_rotate?).to be_falsey
  end

  it "doesn't rotate on zero" do
    subject.rotate = 0
    expect(subject.needs_rotate?).to be_falsey
  end

  it "needs to rotate" do
    subject.rotate = 10
    expect(subject.needs_rotate?).to be_truthy
  end
end
