shared_examples_for "cap DSL method" do
  it "sets the line cap" do
    dsl.cap :curve
    dsl.style[:cap].should eq(:curve)
  end
end
