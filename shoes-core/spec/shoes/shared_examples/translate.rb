# frozen_string_literal: true
shared_examples "object with translate" do
  it "doesn't translate" do
    expect(subject.translate_left).to eq(0)
    expect(subject.translate_top).to eq(0)
  end

  it "translates" do
    subject.translate = [20, 20]
    expect(subject.translate_left).to eq(20)
    expect(subject.translate_top).to eq(20)
  end
end
