shared_examples_for "cap DSL method" do
  it "sets the line cap" do
    dsl.cap :curve
    expect(dsl.style[:cap]).to eq(:curve)
  end
end
