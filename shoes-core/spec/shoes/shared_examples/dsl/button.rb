shared_examples_for "button DSL method" do
  it "is created with a default text" do
    expect(dsl.button.text).to eq 'Button'
  end
end
