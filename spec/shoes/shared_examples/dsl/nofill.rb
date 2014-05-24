shared_examples_for "nofill DSL method" do
  it "sets nil" do
    dsl.nofill
    dsl.style[:fill].should eq(nil)
  end
end
