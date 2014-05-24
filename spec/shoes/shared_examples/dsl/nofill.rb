shared_examples_for "nofill DSL method" do
  it "sets nil" do
    dsl.nofill
    expect(dsl.style[:fill]).to eq(nil)
  end
end
