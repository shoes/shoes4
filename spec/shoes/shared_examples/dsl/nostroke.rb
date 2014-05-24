shared_examples_for "nostroke DSL method" do
  it "sets nil" do
    dsl.nostroke
    expect(dsl.style[:stroke]).to eq(nil)
  end
end
