shared_examples_for "button DSL method" do
  it "can be called without a text" do
    expect{dsl.button}.not_to raise_error
  end
end
