# frozen_string_literal: true

shared_examples_for "nostroke DSL method" do
  it "sets nil" do
    dsl.nostroke
    expect(dsl.style[:stroke]).to eq(nil)
  end

  it "returns the element" do
    returned = dsl.nostroke
    expect(returned).to eq(dsl)
  end
end
