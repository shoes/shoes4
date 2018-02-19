# frozen_string_literal: true

shared_examples_for "nofill DSL method" do
  it "sets nil" do
    dsl.nofill
    expect(dsl.style[:fill]).to eq(nil)
  end

  it "returns the element" do
    returned = dsl.nofill
    expect(returned).to eq(dsl)
  end
end
